# TODO: Define an output for vpc_id
# Requirements:
# - Name it "vpc_id"
# - Description should be "The ID of the VPC"
# - Value should be the ID of the VPC you created
# HINT: Use aws_vpc.lab_vpc.id

# TODO: Define an output for vpc_arn
# Requirements:
# - Name it "vpc_arn"
# - Description should be "The ARN of the VPC"
# - Value should be the ARN of the VPC you created
# HINT: Use aws_vpc.lab_vpc.arn

# TODO: Define an output for vpc_cidr_block
# Requirements:
# - Name it "vpc_cidr_block"
# - Description should be "The CIDR block of the VPC"
# - Value should be the CIDR block of the VPC you created
# HINT: Use aws_vpc.lab_vpc.cidr_block

# TODO: Define an output for public_subnet_ids
# Requirements:
# - Name it "public_subnet_ids"
# - Description should be "List of IDs of public subnets"
# - Value should be a list of all public subnet IDs
# HINT: Use aws_subnet.public_subnets[*].id

# TODO: Define an output for private_subnet_ids
# Requirements:
# - Name it "private_subnet_ids"
# - Description should be "List of IDs of private subnets"
# - Value should be a list of all private subnet IDs
# HINT: Use aws_subnet.private_subnets[*].id

# TODO: Define an output for database_subnet_ids
# Requirements:
# - Name it "database_subnet_ids"
# - Description should be "List of IDs of database subnets"
# - Value should be a list of all database subnet IDs
# HINT: Use aws_subnet.database_subnets[*].id

# TODO: Define an output for public_route_table_id
# Requirements:
# - Name it "public_route_table_id"
# - Description should be "ID of the public route table"
# - Value should be the ID of the public route table
# HINT: Use aws_route_table.public_route_table.id

# TODO: Define an output for private_route_table_id
# Requirements:
# - Name it "private_route_table_id"
# - Description should be "ID of the private route table"
# - Value should be the ID of the private route table
# HINT: Use aws_route_table.private_route_table.id

# TODO: Define an output for database_route_table_id
# Requirements:
# - Name it "database_route_table_id"
# - Description should be "ID of the database route table"
# - Value should be the ID of the database route table
# HINT: Use aws_route_table.database_route_table.id

# TODO: Define an output for internet_gateway_id
# Requirements:
# - Name it "internet_gateway_id"
# - Description should be "ID of the Internet Gateway"
# - Value should be the ID of the Internet Gateway
# HINT: Use aws_internet_gateway.igw.id

# TODO: Define a conditional output for nat_gateway_id
# Requirements:
# - Name it "nat_gateway_id"
# - Description should be "ID of the NAT Gateway (if created)"
# - Value should be the NAT Gateway ID if created, otherwise null
# HINT: Use var.create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : null

# TODO: Define a conditional output for nat_gateway_eip
# Requirements:
# - Name it "nat_gateway_eip"
# - Description should be "Elastic IP address for the NAT Gateway (if created)"
# - Value should be the public IP of the EIP if created, otherwise null
# HINT: Use var.create_nat_gateway ? aws_eip.nat_eip[0].public_ip : null

# TODO: Define an output for public_security_group_id
# Requirements:
# - Name it "public_security_group_id"
# - Description should be "ID of the public security group"
# - Value should be the ID of the public security group
# HINT: Use aws_security_group.public_sg.id

# TODO: Define an output for private_security_group_id
# Requirements:
# - Name it "private_security_group_id"
# - Description should be "ID of the private security group"
# - Value should be the ID of the private security group
# HINT: Use aws_security_group.private_sg.id

# TODO: Define an output for database_security_group_id
# Requirements:
# - Name it "database_security_group_id"
# - Description should be "ID of the database security group"
# - Value should be the ID of the database security group
# HINT: Use aws_security_group.database_sg.id

# TODO: Define a conditional output for s3_endpoint_id
# Requirements:
# - Name it "s3_endpoint_id"
# - Description should be "ID of the S3 VPC endpoint (if created)"
# - Value should be the ID of the S3 endpoint if created, otherwise null
# HINT: Use var.create_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null

# TODO: Define a conditional output for vpc_flow_logs_id
# Requirements:
# - Name it "vpc_flow_logs_id"
# - Description should be "ID of the VPC Flow Logs (if enabled)"
# - Value should be the ID of the VPC Flow Logs if enabled, otherwise null
# HINT: Use var.enable_vpc_flow_logs ? aws_flow_log.vpc_flow_logs[0].id : null

# TODO: Define a conditional output for vpc_flow_logs_role_arn
# Requirements:
# - Name it "vpc_flow_logs_role_arn"
# - Description should be "ARN of the IAM role for VPC Flow Logs (if enabled)"
# - Value should be the ARN of the IAM role if flow logs are enabled, otherwise null
# HINT: Use var.enable_vpc_flow_logs ? aws_iam_role.vpc_flow_logs_role[0].arn : null
