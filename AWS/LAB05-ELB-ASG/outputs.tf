output "elb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.web_lb.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = aws_autoscaling_group.web_asg.name
}

output "security_groups" {
  description = "Security groups attached to the launch template"
  value       = aws_security_group.web_sg.id
}

output "lb_security_group" {
  description = "Security group attached to the load balancer"
  value       = aws_security_group.lb_sg.id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.web_tg.arn
} 
