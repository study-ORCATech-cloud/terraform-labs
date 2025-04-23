output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.lab01_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.lab01_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.lab01_instance.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.lab01_sg.id
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.lab01_instance.public_dns}"
}
