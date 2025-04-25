# LAB06: CloudWatch - Solutions

This document contains solutions to the TODOs in the main.tf file for LAB06.

## Solutions for IAM role, policy attachment, and instance profile

```hcl
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
```

## Solutions for CloudWatch Log Groups

```hcl
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
```

## Solutions for CloudWatch Metric Filters

```hcl
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
```

## Solutions for SNS Topic and Subscription

```hcl
# Create an SNS topic for alarms
resource "aws_sns_topic" "cloudwatch_alarms" {
  name         = "cloudwatch-alarms"
  display_name = "CloudWatch Alarms"
}

# Create SNS subscription if email is provided
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.alarm_email != null ? 1 : 0
  topic_arn = aws_sns_topic.cloudwatch_alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
```

## Solutions for CloudWatch Alarms

```hcl
# Create CloudWatch alarm for high CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when CPU exceeds 80% for 10 minutes"
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
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when memory usage exceeds 80% for 10 minutes"
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
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when disk usage exceeds 80% for 10 minutes"
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
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "Alarm when more than 5 HTTP 404 errors are detected in 5 minutes"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
}
```

## Solution for CloudWatch Dashboard

```hcl
# Create a CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "cloudwatch-lab-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x    = 0
        y    = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.web_server.id]
          ]
          period = 60
          stat = "Average"
          region = var.region
          title = "EC2 Instance CPU"
        }
      },
      {
        type = "metric"
        x    = 12
        y    = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            ["CWAgent", "mem_used_percent", "InstanceId", aws_instance.web_server.id]
          ]
          period = 60
          stat = "Average"
          region = var.region
          title = "Memory Usage"
        }
      },
      {
        type = "metric"
        x    = 0
        y    = 6
        width = 12
        height = 6
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", aws_instance.web_server.id, "path", "/", "fstype", "xfs"]
          ]
          period = 60
          stat = "Average"
          region = var.region
          title = "Disk Usage"
        }
      },
      {
        type = "metric"
        x    = 12
        y    = 6
        width = 12
        height = 6
        properties = {
          metrics = [
            ["WebServer/ErrorCount", "HTTP404Count"],
            ["WebServer/ErrorCount", "HTTP5xxCount"]
          ]
          period = 60
          stat = "Sum"
          region = var.region
          title = "HTTP Error Counts"
        }
      },
      {
        type = "log"
        x    = 0
        y    = 12
        width = 24
        height = 6
        properties = {
          query = "SOURCE '${aws_cloudwatch_log_group.web_access_log.name}' | fields @timestamp, @message\n| sort @timestamp desc\n| limit 20"
          region = var.region
          title = "Web Access Logs"
          view = "table"
        }
      }
    ]
  })
} 