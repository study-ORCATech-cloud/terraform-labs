provider "aws" {
  region = var.region
}

# Create a VPC for the lab
resource "aws_vpc" "cloudwatch_lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "cloudwatch-lab-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cloudwatch_lab_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "cloudwatch-lab-public-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudwatch_lab_vpc.id
  tags = {
    Name = "cloudwatch-lab-igw"
  }
}

# Create route table for public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudwatch_lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "cloudwatch-lab-public-rt"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create security group for EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "cloudwatch-lab-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.cloudwatch_lab_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloudwatch-lab-sg"
  }
}

# Create IAM role for CloudWatch access
resource "aws_iam_role" "cloudwatch_role" {
  name = "EC2CloudWatchRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach CloudWatch policy to IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create instance profile
resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "CloudWatchAgentProfile"
  role = aws_iam_role.cloudwatch_role.name
}

# Create EC2 instance with CloudWatch agent
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.cloudwatch_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd amazon-cloudwatch-agent stress

    # Start and enable Apache
    systemctl start httpd
    systemctl enable httpd
    
    # Create a sample index page
    cat <<HTML > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
        <title>CloudWatch Lab Demo</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }
            h1 { color: #333; }
            .container { max-width: 800px; margin: 0 auto; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>CloudWatch Monitoring Lab</h1>
            <p>This instance is being monitored by CloudWatch.</p>
            <p>Host: $(hostname)</p>
            <p>Date: $(date)</p>
        </div>
    </body>
    </html>
    HTML

    # Configure CloudWatch agent
    cat <<CWAGENT > /opt/aws/amazon-cloudwatch-agent/bin/config.json
    {
      "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "root"
      },
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/httpd/access_log",
                "log_group_name": "${var.web_access_log_group_name}",
                "log_stream_name": "{instance_id}-access-log"
              },
              {
                "file_path": "/var/log/httpd/error_log",
                "log_group_name": "${var.web_error_log_group_name}",
                "log_stream_name": "{instance_id}-error-log"
              },
              {
                "file_path": "/var/log/messages",
                "log_group_name": "${var.system_log_group_name}",
                "log_stream_name": "{instance_id}-messages"
              }
            ]
          }
        }
      },
      "metrics": {
        "metrics_collected": {
          "cpu": {
            "measurement": [
              "cpu_usage_idle",
              "cpu_usage_user",
              "cpu_usage_system"
            ],
            "metrics_collection_interval": 60,
            "totalcpu": true
          },
          "disk": {
            "measurement": [
              "used_percent",
              "inodes_free"
            ],
            "metrics_collection_interval": 60,
            "resources": [
              "/"
            ]
          },
          "mem": {
            "measurement": [
              "mem_used_percent"
            ],
            "metrics_collection_interval": 60
          }
        },
        "append_dimensions": {
          "InstanceId": "$${aws:InstanceId}"
        }
      }
    }
    CWAGENT

    # Start CloudWatch agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

    # Generate logs for testing
    for i in {1..10}; do
      curl http://localhost/ &>/dev/null
      echo "Test log entry $i" | sudo tee -a /var/log/messages
      sleep 2
    done
  EOF

  tags = {
    Name = "cloudwatch-lab-instance"
  }
}

# Create CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "web_access_log" {
  name              = var.web_access_log_group_name
  retention_in_days = 7
  tags = {
    Environment = "lab"
    Application = "webserver"
  }
}

resource "aws_cloudwatch_log_group" "web_error_log" {
  name              = var.web_error_log_group_name
  retention_in_days = 7
  tags = {
    Environment = "lab"
    Application = "webserver"
  }
}

resource "aws_cloudwatch_log_group" "system_log" {
  name              = var.system_log_group_name
  retention_in_days = 7
  tags = {
    Environment = "lab"
    Application = "system"
  }
}

# Create a metric filter for HTTP 404 errors
resource "aws_cloudwatch_log_metric_filter" "http_404_errors" {
  name           = "http-404-errors"
  pattern        = "[ip, identity, user_id, timestamp, request, status_code=404, size]"
  log_group_name = aws_cloudwatch_log_group.web_access_log.name

  metric_transformation {
    name      = "HTTP404Count"
    namespace = "WebServer/ErrorCount"
    value     = "1"
  }
}

# Create a metric filter for HTTP 5xx errors
resource "aws_cloudwatch_log_metric_filter" "http_5xx_errors" {
  name           = "http-5xx-errors"
  pattern        = "[ip, identity, user_id, timestamp, request, status_code=5*, size]"
  log_group_name = aws_cloudwatch_log_group.web_access_log.name

  metric_transformation {
    name      = "HTTP5xxCount"
    namespace = "WebServer/ErrorCount"
    value     = "1"
  }
}

# Create an SNS topic for alarms
resource "aws_sns_topic" "cloudwatch_alarms" {
  name = "cloudwatch-alarms-topic"
}

# Create SNS subscription if email is provided
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.alarm_email != null ? 1 : 0
  topic_arn = aws_sns_topic.cloudwatch_alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# Create CloudWatch alarm for high CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for 2 minutes"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
}

# Create CloudWatch alarm for memory utilization (from CloudWatch agent)
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "high-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when memory usage exceeds 80% for 2 minutes"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
}

# Create CloudWatch alarm for disk utilization
resource "aws_cloudwatch_metric_alarm" "high_disk" {
  alarm_name          = "high-disk-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when disk usage exceeds 80% for 2 minutes"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]

  dimensions = {
    InstanceId = aws_instance.web_server.id
    path       = "/"
    fstype     = "xfs"
  }
}

# Create CloudWatch alarm for HTTP 404 errors
resource "aws_cloudwatch_metric_alarm" "http_404_alarm" {
  alarm_name          = "http-404-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTP404Count"
  namespace           = "WebServer/ErrorCount"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Alarm when more than 5 HTTP 404 errors are detected in 1 minute"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
}

# Create a CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "CloudWatch-Lab-Dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["AWS/EC2", "CPUUtilization", "InstanceId", "${aws_instance.web_server.id}"]
        ],
        "period": 60,
        "stat": "Average",
        "region": "${var.region}",
        "title": "EC2 Instance CPU"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["CWAgent", "mem_used_percent", "InstanceId", "${aws_instance.web_server.id}"]
        ],
        "period": 60,
        "stat": "Average",
        "region": "${var.region}",
        "title": "Memory Usage"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["CWAgent", "disk_used_percent", "InstanceId", "${aws_instance.web_server.id}", "path", "/", "fstype", "xfs"]
        ],
        "period": 60,
        "stat": "Average",
        "region": "${var.region}",
        "title": "Disk Usage"
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 6,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          ["WebServer/ErrorCount", "HTTP404Count"],
          ["WebServer/ErrorCount", "HTTP5xxCount"]
        ],
        "period": 60,
        "stat": "Sum",
        "region": "${var.region}",
        "title": "HTTP Error Counts"
      }
    },
    {
      "type": "log",
      "x": 0,
      "y": 12,
      "width": 24,
      "height": 6,
      "properties": {
        "query": "SOURCE '${aws_cloudwatch_log_group.web_access_log.name}' | fields @timestamp, @message\n| sort @timestamp desc\n| limit 20",
        "region": "${var.region}",
        "title": "Web Access Logs",
        "view": "table"
      }
    }
  ]
}
EOF
} 
