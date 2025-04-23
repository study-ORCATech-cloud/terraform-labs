output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.lab_vpc.id
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.lab_vpc.arn
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.lab_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "database_subnet_ids" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database_subnets[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table.id
}

output "database_route_table_id" {
  description = "ID of the database route table"
  value       = aws_route_table.database_route_table.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway (if created)"
  value       = var.create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : null
}

output "nat_gateway_eip" {
  description = "Elastic IP address for the NAT Gateway (if created)"
  value       = var.create_nat_gateway ? aws_eip.nat_eip[0].public_ip : null
}

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public_sg.id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private_sg.id
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database_sg.id
}

output "s3_endpoint_id" {
  description = "ID of the S3 VPC endpoint (if created)"
  value       = var.create_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

output "vpc_flow_logs_id" {
  description = "ID of the VPC Flow Logs (if enabled)"
  value       = var.enable_vpc_flow_logs ? aws_flow_log.vpc_flow_logs[0].id : null
}

output "vpc_flow_logs_role_arn" {
  description = "ARN of the IAM role for VPC Flow Logs (if enabled)"
  value       = var.enable_vpc_flow_logs ? aws_iam_role.vpc_flow_logs_role[0].arn : null
} 
