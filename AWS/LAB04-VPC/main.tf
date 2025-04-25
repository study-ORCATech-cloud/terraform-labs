provider "aws" {
  region = var.aws_region
}

# ---------------------------------------
# VPC
# ---------------------------------------

# TODO: Create the VPC
# Requirements:
# - Use the vpc_cidr variable for the CIDR block
# - Enable DNS hostnames and DNS support
# - Add tags: Name="{name_prefix}-vpc", Environment, Lab="LAB04-VPC", Terraform="true"
# HINT: Use the aws_vpc resource with enable_dns_hostnames and enable_dns_support

# ---------------------------------------
# Subnets
# ---------------------------------------

# TODO: Create public subnets
# Requirements:
# - Create subnets for each CIDR in public_subnet_cidrs using count
# - Place in different AZs using the availability_zones variable and element() function
# - Enable auto-assign public IP with map_public_ip_on_launch = true
# - Add appropriate tags including a "Type" = "Public" tag
# HINT: Use the aws_subnet resource with count = length(var.public_subnet_cidrs)

# TODO: Create private subnets
# Requirements:
# - Create subnets for each CIDR in private_subnet_cidrs using count
# - Place in different AZs using the availability_zones variable
# - Do NOT enable auto-assign public IP (set to false)
# - Add appropriate tags including a "Type" = "Private" tag
# HINT: Similar to public subnets but with different CIDR blocks and tags

# TODO: Create database subnets
# Requirements:
# - Create subnets for each CIDR in database_subnet_cidrs using count
# - Place in different AZs using the availability_zones variable
# - Do NOT enable auto-assign public IP (set to false)
# - Add appropriate tags including a "Type" = "Database" tag
# HINT: Similar to private subnets but with different CIDR blocks and tags

# ---------------------------------------
# Internet Gateway and NAT Gateway
# ---------------------------------------

# TODO: Create an Internet Gateway
# Requirements:
# - Attach it to the VPC created above
# - Add appropriate tags
# HINT: Use the aws_internet_gateway resource with vpc_id

# TODO: Create Elastic IP for NAT Gateway
# Requirements:
# - Only create if var.create_nat_gateway is true
# - Set domain = "vpc"
# - Add appropriate tags
# HINT: Use count = var.create_nat_gateway ? 1 : 0 

# TODO: Create NAT Gateway
# Requirements:
# - Only create if var.create_nat_gateway is true
# - Use the Elastic IP created above
# - Place in the first public subnet
# - Add appropriate tags
# - Add an explicit dependency on the Internet Gateway
# HINT: Use depends_on = [aws_internet_gateway.igw]

# ---------------------------------------
# Route Tables and Routes
# ---------------------------------------

# TODO: Create public route table
# Requirements:
# - Associate with the VPC
# - Add appropriate tags including a "Type" = "Public" tag
# HINT: Use the aws_route_table resource

# TODO: Create public route to Internet Gateway
# Requirements:
# - Add a default route (0.0.0.0/0) pointing to the Internet Gateway
# HINT: Use the aws_route resource with destination_cidr_block = "0.0.0.0/0"

# TODO: Create private route table
# Requirements:
# - Associate with the VPC
# - Add appropriate tags including a "Type" = "Private" tag
# HINT: Similar to the public route table

# TODO: Create private route to NAT Gateway (if enabled)
# Requirements:
# - Only create if var.create_nat_gateway is true
# - Add a default route (0.0.0.0/0) pointing to the NAT Gateway
# HINT: Use count and reference the NAT Gateway with index [0]

# TODO: Create database route table
# Requirements:
# - Associate with the VPC
# - Add appropriate tags including a "Type" = "Database" tag
# HINT: Similar to the private route table

# TODO: Associate public subnets with public route table
# Requirements:
# - Loop through each public subnet using count
# - Associate each subnet with the public route table
# HINT: Use the aws_route_table_association resource

# TODO: Associate private subnets with private route table
# Requirements:
# - Loop through each private subnet using count
# - Associate each subnet with the private route table
# HINT: Similar to the public subnet associations

# TODO: Associate database subnets with database route table
# Requirements:
# - Loop through each database subnet using count
# - Associate each subnet with the database route table
# HINT: Similar to the private subnet associations

# ---------------------------------------
# NACL (Network Access Control Lists)
# ---------------------------------------

# TODO: Create NACL for public subnets
# Requirements:
# - Associate with the VPC and all public subnets
# - Add appropriate tags including a "Type" = "Public" tag
# HINT: Use aws_network_acl with subnet_ids = aws_subnet.public_subnets[*].id

# TODO: Create NACL for private subnets
# Requirements:
# - Associate with the VPC and all private subnets
# - Add appropriate tags including a "Type" = "Private" tag
# HINT: Similar to the public NACL

# TODO: Create NACL for database subnets
# Requirements:
# - Associate with the VPC and all database subnets
# - Add appropriate tags including a "Type" = "Database" tag
# HINT: Similar to the private NACL

# TODO: Create NACL rules for public subnets - ingress
# Requirements:
# - Use the public_inbound_acl_rules variable with count
# - Set egress = false for inbound rules
# - Configure the rule number, action, ports, protocol, and CIDR from the variable
# HINT: Use lookup() for optional fields that might be null

# TODO: Create NACL rules for public subnets - egress
# Requirements:
# - Use the public_outbound_acl_rules variable with count
# - Set egress = true for outbound rules
# - Configure the rule number, action, ports, protocol, and CIDR from the variable
# HINT: Similar to the ingress rules but with egress = true

# ---------------------------------------
# Security Groups
# ---------------------------------------

# TODO: Create security group for public instances
# Requirements:
# - Name it "{name_prefix}-public-sg"
# - Create ingress rules for SSH (22), HTTP (80), and HTTPS (443) from anywhere (0.0.0.0/0)
# - Create an egress rule allowing all outbound traffic
# - Add appropriate tags
# HINT: Use aws_security_group with multiple ingress blocks

# TODO: Create security group for private instances
# Requirements:
# - Name it "{name_prefix}-private-sg"
# - Create ingress rules for SSH (22), HTTP (80), and HTTPS (443) from within VPC only
# - Create an egress rule allowing all outbound traffic
# - Add appropriate tags
# HINT: Similar to public SG but with cidr_blocks = [var.vpc_cidr]

# TODO: Create security group for database instances
# Requirements:
# - Name it "{name_prefix}-database-sg"
# - Create ingress rules for MySQL (3306) and PostgreSQL (5432) from private instances only
# - Create an egress rule allowing all outbound traffic
# - Add appropriate tags
# HINT: Use security_groups = [aws_security_group.private_sg.id] for the ingress rules

# ---------------------------------------
# VPC Endpoints (Optional)
# ---------------------------------------

# TODO: Create S3 VPC endpoint if enabled
# Requirements:
# - Only create if var.create_s3_endpoint is true
# - Connect to the VPC and use the S3 service in the current region
# - Add appropriate tags
# HINT: Use count and service_name = "com.amazonaws.${var.aws_region}.s3"

# TODO: Associate S3 endpoint with private route table
# Requirements:
# - Only create if var.create_s3_endpoint is true
# - Associate the S3 endpoint with the private route table
# HINT: Use aws_vpc_endpoint_route_table_association with count

# ---------------------------------------
# Optional: VPC Flow Logs
# ---------------------------------------

# TODO: Create CloudWatch log group for VPC Flow Logs
# Requirements:
# - Only create if var.enable_vpc_flow_logs is true
# - Name it "/aws/vpc/flow-logs/{vpc-id}"
# - Set retention to 7 days
# - Add appropriate tags
# HINT: Use count and reference the VPC ID

# TODO: Create IAM role for VPC Flow Logs
# Requirements:
# - Only create if var.enable_vpc_flow_logs is true
# - Name it "{name_prefix}-vpc-flow-logs-role"
# - Create an assume_role_policy that allows vpc-flow-logs.amazonaws.com to assume the role
# - Add appropriate tags
# HINT: Use jsonencode for the assume_role_policy

# TODO: Create IAM policy for VPC Flow Logs
# Requirements:
# - Only create if var.enable_vpc_flow_logs is true
# - Name it "{name_prefix}-vpc-flow-logs-policy"
# - Add permissions to create log streams, put log events, and describe log groups/streams
# - Attach to the IAM role created above
# HINT: Use jsonencode for the policy document

# TODO: Create VPC Flow Logs
# Requirements:
# - Only create if var.enable_vpc_flow_logs is true
# - Set log destination to the CloudWatch log group ARN
# - Set log_destination_type to "cloud-watch-logs"
# - Capture all traffic (traffic_type = "ALL")
# - Use the IAM role created above
# - Add appropriate tags
# HINT: Use aws_flow_log with count 
