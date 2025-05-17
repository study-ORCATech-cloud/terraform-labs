# LAB06: CloudWatch - Solutions

This document contains solutions to the TODOs in the main.tf file for LAB06.

## Getting Started

After implementing each solution section, follow these additional steps:

1. **Update the EC2 Instance** - After implementing the IAM role and instance profile:
   ```hcl
   # In main.tf, uncomment this line in the aws_instance "web_server" resource:
   iam_instance_profile = aws_iam_instance_profile.cloudwatch_profile.name
   ```

2. **Uncomment Outputs** - After implementing each resource section, uncomment the corresponding outputs in outputs.tf.

## Solutions for IAM Role and Instance Profile

```hcl
# IAM role for CloudWatch access
resource "aws_iam_role" "cloudwatch_role" {
  name = "${var.name_prefix}-cloudwatch-role"

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

  tags = {
    Name        = "${var.name_prefix}-cloudwatch-role"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# Attach CloudWatch policy to IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create instance profile
resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "${var.name_prefix}-cloudwatch-profile"
  role = aws_iam_role.cloudwatch_role.name
}
```

## Solutions for CloudWatch Log Groups

```hcl
# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "web_access_log" {
  name              = var.web_access_log_group_name
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.name_prefix}-web-access-logs"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

resource "aws_cloudwatch_log_group" "web_error_log" {
  name              = var.web_error_log_group_name
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.name_prefix}-web-error-logs"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

resource "aws_cloudwatch_log_group" "system_log" {
  name              = var.system_log_group_name
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.name_prefix}-system-logs"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}
```

## Solutions for CloudWatch Metric Filters

```hcl
# Metric filter for HTTP 404 errors
resource "aws_cloudwatch_log_metric_filter" "http_404_errors" {
  name           = "${var.name_prefix}-http-404-errors"
  pattern        = "[ip, id, user, timestamp, request, status_code=404, size]"
  log_group_name = aws_cloudwatch_log_group.web_access_log.name

  metric_transformation {
    name      = "HTTP404Errors"
    namespace = "WebServer"
    value     = "1"
  }
}

# Metric filter for HTTP 5XX errors
resource "aws_cloudwatch_log_metric_filter" "http_5xx_errors" {
  name           = "${var.name_prefix}-http-5xx-errors"
  pattern        = "[ip, id, user, timestamp, request, status_code=5*, size]"
  log_group_name = aws_cloudwatch_log_group.web_access_log.name

  metric_transformation {
    name      = "HTTP5xxErrors"
    namespace = "WebServer"
    value     = "1"
  }
}
```

## Solutions for SNS Topic and Subscription

```hcl
# SNS Topic for CloudWatch Alarms
resource "aws_sns_topic" "cloudwatch_alarms" {
  name         = "${var.name_prefix}-cloudwatch-alarms"
  display_name = "CloudWatch Alarms"
  
  tags = {
    Name        = "${var.name_prefix}-cloudwatch-alarms"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# SNS Topic Subscription for email notification
resource "aws_sns_topic_subscription" "email_subscription" {
  count     = var.alarm_email != null ? 1 : 0
  topic_arn = aws_sns_topic.cloudwatch_alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}
```

## Solutions for CloudWatch Alarms

```hcl
# High CPU utilization alarm
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "${var.name_prefix}-high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
  
  tags = {
    Name        = "${var.name_prefix}-high-cpu-alarm"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# High memory utilization alarm
resource "aws_cloudwatch_metric_alarm" "memory_utilization_alarm" {
  alarm_name          = "${var.name_prefix}-high-memory-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = var.memory_alarm_threshold
  alarm_description   = "This metric monitors memory utilization"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
  
  tags = {
    Name        = "${var.name_prefix}-high-memory-alarm"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# High disk usage alarm
resource "aws_cloudwatch_metric_alarm" "disk_usage_alarm" {
  alarm_name          = "${var.name_prefix}-high-disk-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = var.disk_alarm_threshold
  alarm_description   = "This metric monitors disk usage"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  dimensions = {
    InstanceId = aws_instance.web_server.id
    path       = "/"
    fstype     = "xfs"
  }
  
  tags = {
    Name        = "${var.name_prefix}-high-disk-alarm"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}

# HTTP 404 errors alarm
resource "aws_cloudwatch_metric_alarm" "http_404_errors_alarm" {
  alarm_name          = "${var.name_prefix}-404-errors-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTP404Errors"
  namespace           = "WebServer"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "This metric monitors HTTP 404 errors"
  alarm_actions       = [aws_sns_topic.cloudwatch_alarms.arn]
  
  tags = {
    Name        = "${var.name_prefix}-404-errors-alarm"
    Environment = var.environment
    Lab         = "LAB06-CLOUDWATCH"
    Terraform   = "true"
  }
}
```

## Solution for CloudWatch Dashboard

```hcl
# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.name_prefix}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.web_server.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["CWAgent", "mem_used_percent", "InstanceId", aws_instance.web_server.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Memory Usage"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["CWAgent", "disk_used_percent", "InstanceId", aws_instance.web_server.id, "path", "/", "fstype", "xfs"]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Disk Usage"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["WebServer", "HTTP404Errors"],
            ["WebServer", "HTTP5xxErrors"]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "HTTP Errors"
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 6
        properties = {
          query   = "SOURCE '${var.web_access_log_group_name}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
          region  = var.aws_region
          title   = "Recent Web Access Logs"
          view    = "table"
        }
      }
    ]
  })
} 