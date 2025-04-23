output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "web_access_log_group" {
  description = "Name of the web access log group"
  value       = aws_cloudwatch_log_group.web_access_log.name
}

output "web_error_log_group" {
  description = "Name of the web error log group"
  value       = aws_cloudwatch_log_group.web_error_log.name
}

output "system_log_group" {
  description = "Name of the system log group"
  value       = aws_cloudwatch_log_group.system_log.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for CloudWatch alarms"
  value       = aws_sns_topic.cloudwatch_alarms.arn
}

output "dashboard_url" {
  description = "URL for the CloudWatch dashboard"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}
