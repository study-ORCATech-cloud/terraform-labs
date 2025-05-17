# ---------------------------------------
# VPC and Networking
# ---------------------------------------

# Create a VPC for the lab
resource "aws_vpc" "cloudwatch_lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.name_prefix}-vpc"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cloudwatch_lab_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name        = "${var.name_prefix}-public-subnet"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloudwatch_lab_vpc.id
  tags = {
    Name        = "${var.name_prefix}-igw"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
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
    Name        = "${var.name_prefix}-public-rt"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------------------------------
# Security Group
# ---------------------------------------

# Create security group for EC2 instance
resource "aws_security_group" "instance_sg" {
  name        = "${var.name_prefix}-sg"
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
    Name        = "${var.name_prefix}-sg"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# ---------------------------------------
# IAM Role and Policy
# ---------------------------------------

# TODO: Create IAM role for CloudWatch access
# Requirements:
# - Name the role "${var.name_prefix}-cloudwatch-role"
# - Use the EC2 service as the principal in the assume role policy
# - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
# HINT: Use jsonencode for the assume_role_policy document

# TODO: Attach CloudWatch policy to IAM role
# Requirements:
# - Attach the AWS managed policy "CloudWatchAgentServerPolicy" to the role
# - Use the role created in the previous step
# HINT: Use aws_iam_role_policy_attachment resource with the correct policy ARN: "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

# TODO: Create instance profile
# Requirements:
# - Name the profile "${var.name_prefix}-cloudwatch-profile"
# - Associate it with the IAM role you created
# HINT: Use aws_iam_instance_profile resource

# ---------------------------------------
# EC2 Instance with CloudWatch Agent
# ---------------------------------------

# Create EC2 instance with CloudWatch agent
# This will be created after the IAM role and instance profile have been implemented
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  # This resource will be referenced from your solution
  # iam_instance_profile   = aws_iam_instance_profile.cloudwatch_profile.name
  key_name = var.key_name

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

    # Start the CloudWatch agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    
    # Generate some test log entries
    echo "This is a test log entry for CloudWatch" >> /var/log/messages
    curl -s http://localhost/index.html > /dev/null
    curl -s http://localhost/nonexistent > /dev/null
  EOF

  tags = {
    Name        = "${var.name_prefix}-web-server"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# ---------------------------------------
# CloudWatch Log Groups
# ---------------------------------------

# TODO: Create CloudWatch Log Groups
# Requirements:
# - Create three log groups for web access logs, web error logs, and system logs
# - Use the variable names provided in variables.tf
# - Set retention to var.log_retention_days
# - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
# HINT: Use the aws_cloudwatch_log_group resource with retention_in_days attribute

# ---------------------------------------
# CloudWatch Metrics and Filters
# ---------------------------------------

# TODO: Create CloudWatch Metric Filters for HTTP errors
# Requirements:
# - Create a metric filter for HTTP 404 errors in the web access log group
# - Create a metric filter for HTTP 5xx errors in the web access log group
# - Use appropriate pattern expressions to detect these errors in Apache logs
# - Configure the metric name, namespace, and value appropriately
# HINT: Use the aws_cloudwatch_log_metric_filter resource with pattern and metric_transformation

# ---------------------------------------
# SNS Topics and Subscriptions
# ---------------------------------------

# TODO: Create an SNS Topic for CloudWatch Alarms
# Requirements:
# - Name the topic "${var.name_prefix}-cloudwatch-alarms"
# - Add a display name of "CloudWatch Alarms"
# - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
# HINT: Use the aws_sns_topic resource

# TODO: Create an SNS Topic Subscription for email notification
# Requirements:
# - Only create if var.alarm_email is provided
# - Use the email protocol and the email address from var.alarm_email
# - Subscribe to the SNS topic created in the previous step
# HINT: Use count conditional based on var.alarm_email and protocol = "email"

# ---------------------------------------
# CloudWatch Alarms
# ---------------------------------------

# TODO: Create CloudWatch Alarms
# Requirements:
# 1. Create a high CPU alarm:
#    - Name it "${var.name_prefix}-high-cpu-alarm"
#    - Trigger when CPU utilization > var.cpu_alarm_threshold% for 2 consecutive periods
#    - Use the "CPUUtilization" metric from AWS/EC2 namespace
#    - Compare against the average statistic
#    - Set evaluation periods to 2 and period to 300 seconds
#    - Configure actions to notify the SNS topic
#    - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
#
# 2. Create a high memory alarm:
#    - Name it "${var.name_prefix}-high-memory-alarm"
#    - Trigger when memory used > var.memory_alarm_threshold% for 2 consecutive periods
#    - Use the "mem_used_percent" metric from CWAgent namespace
#    - Compare against the average statistic
#    - Set evaluation periods to 2 and period to 300 seconds
#    - Configure actions to notify the SNS topic
#    - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
#
# 3. Create a high disk usage alarm:
#    - Name it "${var.name_prefix}-high-disk-alarm"
#    - Trigger when disk used > var.disk_alarm_threshold% for 2 consecutive periods
#    - Use the "disk_used_percent" metric from CWAgent namespace
#    - Compare against the average statistic
#    - Set evaluation periods to 2 and period to 300 seconds
#    - Configure actions to notify the SNS topic
#    - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
#
# 4. Create an HTTP 404 errors alarm:
#    - Name it "${var.name_prefix}-404-errors-alarm"
#    - Trigger when more than 5 HTTP 404 errors occur in 5 minutes
#    - Use the metric created by the HTTP 404 metric filter
#    - Compare against the sum statistic
#    - Set threshold to 5 and period to 300 seconds
#    - Configure actions to notify the SNS topic
#    - Add tags: Name, Environment, Lab="LAB06-CLOUDWATCH", Terraform="true"
#
# HINT: Use the aws_cloudwatch_metric_alarm resource with appropriate settings

# ---------------------------------------
# CloudWatch Dashboard
# ---------------------------------------

# TODO: Create CloudWatch Dashboard
# Requirements:
# - Create a dashboard named "${var.name_prefix}-dashboard"
# - Include widgets for:
#   1. CPU utilization line graph
#   2. Memory usage line graph
#   3. Disk usage line graph
#   4. HTTP errors count graph
#   5. Latest web access logs
# - Use an appropriate layout with multiple rows and columns
# HINT: Use aws_cloudwatch_dashboard with dashboard_body as a JSON string
# HINT: Use jsonencode to create the JSON structure for the dashboard 
