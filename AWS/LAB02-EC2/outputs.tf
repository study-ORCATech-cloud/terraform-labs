output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.web.id
}

output "ec2-arn" {
  value       = aws_instance.ec2.arn
  description = "ARN of the created EC2 machine"
}

output "ec2-public-ip" {
  value       = aws_instance.ec2.public_ip
  description = "Public IP address of the created EC2 machine"
}

