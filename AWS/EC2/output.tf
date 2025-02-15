output "ec2-arn" {
  value       = aws_instance.ec2.arn
  description = "ARN of the created EC2 machine"
}
