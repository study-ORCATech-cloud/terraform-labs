provider "aws" {
  region = var.aws_region
}

# ---------------------------------------
# VPC
# ---------------------------------------

# Create the VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.name_prefix}-vpc"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# ---------------------------------------
# Subnets
# ---------------------------------------

# Create public subnets
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.name_prefix}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Public"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name_prefix}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Private"
  }
}

# Create database subnets
resource "aws_subnet" "database_subnets" {
  count = length(var.database_subnet_cidrs)

  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = var.database_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.name_prefix}-database-subnet-${count.index + 1}"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Database"
  }
}

# ---------------------------------------
# Internet Gateway and NAT Gateway
# ---------------------------------------

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "${var.name_prefix}-igw"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name        = "${var.name_prefix}-nat-eip"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name        = "${var.name_prefix}-nat-gateway"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC
  depends_on = [aws_internet_gateway.igw]
}

# ---------------------------------------
# Route Tables and Routes
# ---------------------------------------

# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "${var.name_prefix}-public-rt"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Public"
  }
}

# Create public route
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Create private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "${var.name_prefix}-private-rt"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Private"
  }
}

# Create private route to NAT Gateway (if enabled)
resource "aws_route" "private_nat_route" {
  count                  = var.create_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[0].id
}

# Create database route table
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = {
    Name        = "${var.name_prefix}-database-rt"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Database"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate database subnets with database route table
resource "aws_route_table_association" "database_rt_association" {
  count          = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database_subnets[count.index].id
  route_table_id = aws_route_table.database_route_table.id
}

# ---------------------------------------
# NACL (Network Access Control Lists)
# ---------------------------------------

# Create NACL for public subnets
resource "aws_network_acl" "public_nacl" {
  vpc_id     = aws_vpc.lab_vpc.id
  subnet_ids = aws_subnet.public_subnets[*].id

  tags = {
    Name        = "${var.name_prefix}-public-nacl"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Public"
  }
}

# Create NACL for private subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id     = aws_vpc.lab_vpc.id
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name        = "${var.name_prefix}-private-nacl"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Private"
  }
}

# Create NACL for database subnets
resource "aws_network_acl" "database_nacl" {
  vpc_id     = aws_vpc.lab_vpc.id
  subnet_ids = aws_subnet.database_subnets[*].id

  tags = {
    Name        = "${var.name_prefix}-database-nacl"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
    Type        = "Database"
  }
}

# NACL rules for public subnets - ingress
resource "aws_network_acl_rule" "public_ingress" {
  count          = length(var.public_inbound_acl_rules)
  network_acl_id = aws_network_acl.public_nacl.id

  egress      = false
  rule_number = var.public_inbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_inbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
  protocol    = var.public_inbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
}

# NACL rules for public subnets - egress
resource "aws_network_acl_rule" "public_egress" {
  count          = length(var.public_outbound_acl_rules)
  network_acl_id = aws_network_acl.public_nacl.id

  egress      = true
  rule_number = var.public_outbound_acl_rules[count.index]["rule_number"]
  rule_action = var.public_outbound_acl_rules[count.index]["rule_action"]
  from_port   = lookup(var.public_outbound_acl_rules[count.index], "from_port", null)
  to_port     = lookup(var.public_outbound_acl_rules[count.index], "to_port", null)
  protocol    = var.public_outbound_acl_rules[count.index]["protocol"]
  cidr_block  = lookup(var.public_outbound_acl_rules[count.index], "cidr_block", null)
}

# ---------------------------------------
# Security Groups
# ---------------------------------------

# Create default security group for public instances
resource "aws_security_group" "public_sg" {
  name        = "${var.name_prefix}-public-sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.lab_vpc.id

  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"
  }

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS access from anywhere"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.name_prefix}-public-sg"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Create default security group for private instances
resource "aws_security_group" "private_sg" {
  name        = "${var.name_prefix}-private-sg"
  description = "Security group for private instances"
  vpc_id      = aws_vpc.lab_vpc.id

  # Allow SSH from VPC CIDR
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow SSH access from within VPC"
  }

  # Allow HTTP from VPC CIDR
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow HTTP access from within VPC"
  }

  # Allow HTTPS from VPC CIDR
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow HTTPS access from within VPC"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.name_prefix}-private-sg"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Create default security group for database instances
resource "aws_security_group" "database_sg" {
  name        = "${var.name_prefix}-database-sg"
  description = "Security group for database instances"
  vpc_id      = aws_vpc.lab_vpc.id

  # Allow MySQL/Aurora from private subnets
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
    description     = "Allow MySQL/Aurora access from private instances"
  }

  # Allow PostgreSQL from private subnets
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
    description     = "Allow PostgreSQL access from private instances"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.name_prefix}-database-sg"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# ---------------------------------------
# VPC Endpoints (Optional)
# ---------------------------------------

# Create S3 VPC endpoint if enabled
resource "aws_vpc_endpoint" "s3" {
  count        = var.create_s3_endpoint ? 1 : 0
  vpc_id       = aws_vpc.lab_vpc.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = {
    Name        = "${var.name_prefix}-s3-endpoint"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Associate S3 endpoint with route tables
resource "aws_vpc_endpoint_route_table_association" "private_s3_endpoint" {
  count           = var.create_s3_endpoint ? 1 : 0
  route_table_id  = aws_route_table.private_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}

# ---------------------------------------
# Optional: VPC Flow Logs
# ---------------------------------------

# Create CloudWatch log group for VPC Flow Logs if enabled
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count             = var.enable_vpc_flow_logs ? 1 : 0
  name              = "/aws/vpc/flow-logs/${aws_vpc.lab_vpc.id}"
  retention_in_days = 7

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-logs"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Create IAM role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  count = var.enable_vpc_flow_logs ? 1 : 0
  name  = "${var.name_prefix}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-logs-role"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
}

# Create IAM policy for VPC Flow Logs
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  count = var.enable_vpc_flow_logs ? 1 : 0
  name  = "${var.name_prefix}-vpc-flow-logs-policy"
  role  = aws_iam_role.vpc_flow_logs_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Create VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  count                = var.enable_vpc_flow_logs ? 1 : 0
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.lab_vpc.id
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role[0].arn

  tags = {
    Name        = "${var.name_prefix}-vpc-flow-logs"
    Environment = var.environment
    Lab         = "LAB04-VPC"
    Terraform   = "true"
  }
} 
