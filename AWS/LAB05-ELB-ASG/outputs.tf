output "elb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = aws_autoscaling_group.app_asg.name
}

output "instance_security_group" {
  description = "Security group attached to the instances"
  value       = aws_security_group.instance_sg.id
}

output "lb_security_group" {
  description = "Security group attached to the load balancer"
  value       = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app_tg.arn
}
