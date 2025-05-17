# TODO: Define an output for instance_id
# Requirements:
# - Name it "instance_id"
# - Description should be "ID of the EC2 instance"
# - Value should be the ID of the EC2 instance
# HINT: Use aws_instance.web_server.id
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

# TODO: Define an output for instance_public_ip
# Requirements:
# - Name it "instance_public_ip"
# - Description should be "Public IP address of the EC2 instance"
# - Value should be the public IP address of the EC2 instance
# HINT: Use aws_instance.web_server.public_ip
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

# TODO: Define an output for web_access_log_group
# Requirements:
# - Name it "web_access_log_group"
# - Description should be "Name of the web access log group"
# - Value should be the name of the web access log group
# HINT: Use aws_cloudwatch_log_group.web_access_log.name
# This output will be uncommented after completing the CloudWatch Log Groups TODO
# output "web_access_log_group" {
#   description = "Name of the web access log group"
#   value       = aws_cloudwatch_log_group.web_access_log.name
# }

# TODO: Define an output for web_error_log_group
# Requirements:
# - Name it "web_error_log_group"
# - Description should be "Name of the web error log group"
# - Value should be the name of the web error log group
# HINT: Use aws_cloudwatch_log_group.web_error_log.name
# This output will be uncommented after completing the CloudWatch Log Groups TODO
# output "web_error_log_group" {
#   description = "Name of the web error log group"
#   value       = aws_cloudwatch_log_group.web_error_log.name
# }

# TODO: Define an output for system_log_group
# Requirements:
# - Name it "system_log_group"
# - Description should be "Name of the system log group"
# - Value should be the name of the system log group
# HINT: Use aws_cloudwatch_log_group.system_log.name
# This output will be uncommented after completing the CloudWatch Log Groups TODO
# output "system_log_group" {
#   description = "Name of the system log group"
#   value       = aws_cloudwatch_log_group.system_log.name
# }

# TODO: Define an output for sns_topic_arn
# Requirements:
# - Name it "sns_topic_arn"
# - Description should be "ARN of the SNS topic for CloudWatch alarms"
# - Value should be the ARN of the SNS topic
# HINT: Use aws_sns_topic.cloudwatch_alarms.arn
# This output will be uncommented after completing the SNS Topic TODO
# output "sns_topic_arn" {
#   description = "ARN of the SNS topic for CloudWatch alarms"
#   value       = aws_sns_topic.cloudwatch_alarms.arn
# }

# TODO: Define an output for dashboard_url
# Requirements:
# - Name it "dashboard_url"
# - Description should be "URL for the CloudWatch dashboard"
# - Value should be the URL for accessing the CloudWatch dashboard
# HINT: Use string interpolation with the AWS region and dashboard name
# This output will be uncommented after completing the CloudWatch Dashboard TODO
# output "dashboard_url" {
#   description = "URL for the CloudWatch dashboard"
#   value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
# }

# TODO: Define an output for cpu_utilization_alarm_arn
# Requirements:
# - Name it "cpu_utilization_alarm_arn"
# - Description should be "ARN of the CPU utilization alarm"
# - Value should be the ARN of the CPU utilization alarm
# HINT: Use aws_cloudwatch_metric_alarm.cpu_utilization_alarm.arn
# This output will be uncommented after completing the CloudWatch Alarms TODO
# output "cpu_utilization_alarm_arn" {
#   description = "ARN of the CPU utilization alarm"
#   value       = aws_cloudwatch_metric_alarm.cpu_utilization_alarm.arn
# }

# TODO: Define an output for memory_utilization_alarm_arn
# Requirements:
# - Name it "memory_utilization_alarm_arn"
# - Description should be "ARN of the memory utilization alarm"
# - Value should be the ARN of the memory utilization alarm
# HINT: Use aws_cloudwatch_metric_alarm.memory_utilization_alarm.arn
# This output will be uncommented after completing the CloudWatch Alarms TODO
# output "memory_utilization_alarm_arn" {
#   description = "ARN of the memory utilization alarm"
#   value       = aws_cloudwatch_metric_alarm.memory_utilization_alarm.arn
# }
