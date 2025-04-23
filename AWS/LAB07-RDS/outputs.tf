output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.mysql_db.endpoint
}

output "rds_port" {
  description = "The port on which the RDS instance accepts connections"
  value       = aws_db_instance.mysql_db.port
}

output "rds_username" {
  description = "The master username for the RDS instance"
  value       = aws_db_instance.mysql_db.username
  sensitive   = true
}

output "rds_database_name" {
  description = "The name of the initial database"
  value       = aws_db_instance.mysql_db.db_name
}

output "rds_vpc_id" {
  description = "ID of the VPC in which the RDS instance is deployed"
  value       = aws_vpc.rds_vpc.id
}

output "rds_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.name
}

output "rds_security_group_id" {
  description = "ID of the security group attached to the RDS instance"
  value       = aws_security_group.rds_sg.id
}

output "rds_parameter_group_name" {
  description = "Name of the DB parameter group"
  value       = aws_db_parameter_group.rds_param_group.name
}

output "client_instance_public_ip" {
  description = "Public IP address of the client EC2 instance"
  value       = var.create_client_instance ? aws_instance.mysql_client[0].public_ip : null
}

output "client_instance_id" {
  description = "ID of the client EC2 instance"
  value       = var.create_client_instance ? aws_instance.mysql_client[0].id : null
}

output "connection_string" {
  description = "MySQL connection string"
  value       = "mysql -h ${aws_db_instance.mysql_db.address} -P ${aws_db_instance.mysql_db.port} -u ${var.db_username} -p${var.db_password} ${var.db_name}"
  sensitive   = true
} 
