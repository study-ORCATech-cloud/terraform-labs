provider "aws" {
  region = var.region
}

# Create a VPC for the RDS instance
resource "aws_vpc" "rds_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "rds-vpc"
  }
}

# Create subnets in different availability zones for high availability
resource "aws_subnet" "rds_subnet_1" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = var.subnet_cidr_1
  availability_zone = "${var.region}a"
  tags = {
    Name = "rds-subnet-1a"
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = var.subnet_cidr_2
  availability_zone = "${var.region}b"
  tags = {
    Name = "rds-subnet-2b"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "rds_igw" {
  vpc_id = aws_vpc.rds_vpc.id
  tags = {
    Name = "rds-igw"
  }
}

# Create a route table for public access
resource "aws_route_table" "rds_public_rt" {
  vpc_id = aws_vpc.rds_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rds_igw.id
  }

  tags = {
    Name = "rds-public-rt"
  }
}

# Associate the route table with the subnets
resource "aws_route_table_association" "rds_rta_1" {
  subnet_id      = aws_subnet.rds_subnet_1.id
  route_table_id = aws_route_table.rds_public_rt.id
}

resource "aws_route_table_association" "rds_rta_2" {
  subnet_id      = aws_subnet.rds_subnet_2.id
  route_table_id = aws_route_table.rds_public_rt.id
}

# Create a security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.rds_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
    description = "Allow MySQL traffic from specified CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "rds-sg"
  }
}

# Create an EC2 security group for the client instance
resource "aws_security_group" "client_sg" {
  name        = "mysql-client-sg"
  description = "Security group for MySQL client"
  vpc_id      = aws_vpc.rds_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "mysql-client-sg"
  }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Create a DB parameter group
resource "aws_db_parameter_group" "rds_param_group" {
  name        = "rds-mysql-params"
  family      = "mysql8.0"
  description = "Custom parameter group for MySQL 8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "max_connections"
    value = "150"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  tags = {
    Name = "RDS Parameter Group"
  }
}

# Create an option group
resource "aws_db_option_group" "rds_option_group" {
  name                     = "rds-mysql-options"
  option_group_description = "Option group for MySQL 8.0"
  engine_name              = "mysql"
  major_engine_version     = "8.0"

  tags = {
    Name = "RDS Option Group"
  }
}

# Create the RDS instance
resource "aws_db_instance" "mysql_db" {
  identifier                      = var.db_identifier
  engine                          = "mysql"
  engine_version                  = "8.0"
  instance_class                  = var.db_instance_class
  allocated_storage               = var.allocated_storage
  storage_type                    = "gp2"
  storage_encrypted               = true
  db_name                         = var.db_name
  username                        = var.db_username
  password                        = var.db_password
  port                            = 3306
  publicly_accessible             = var.publicly_accessible
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.name
  parameter_group_name            = aws_db_parameter_group.rds_param_group.name
  option_group_name               = aws_db_option_group.rds_option_group.name
  backup_retention_period         = var.backup_retention_period
  backup_window                   = "03:00-04:00"
  maintenance_window              = "Mon:04:00-Mon:05:00"
  multi_az                        = var.multi_az
  skip_final_snapshot             = true
  deletion_protection             = false
  copy_tags_to_snapshot           = true
  monitoring_interval             = 60
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  tags = {
    Name        = "MySQL-RDS-Instance"
    Environment = "Lab"
  }
}

# Create an EC2 instance to use as a MySQL client
resource "aws_instance" "mysql_client" {
  count                       = var.create_client_instance ? 1 : 0
  ami                         = var.client_ami_id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.rds_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.client_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y mysql

# Wait for the RDS instance to be available
echo "Waiting for RDS instance to be available..."
sleep 60

# Store connection details in variables
DB_HOST="${aws_db_instance.mysql_db.address}"
DB_PORT="${aws_db_instance.mysql_db.port}"
DB_USER="${var.db_username}"
DB_PASS="${var.db_password}"
DB_NAME="${var.db_name}"

# Create a script to connect to the MySQL database
cat > /home/ec2-user/connect-to-db.sh << SCRIPT
#!/bin/bash
mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASS $DB_NAME
SCRIPT

chmod +x /home/ec2-user/connect-to-db.sh
chown ec2-user:ec2-user /home/ec2-user/connect-to-db.sh

# Create a sample SQL script
cat > /home/ec2-user/create-tables.sql << SQL
-- Sample database setup
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, email) 
VALUES ('admin', 'admin@example.com'),
       ('test_user', 'test@example.com');

SELECT * FROM users;
SQL

chown ec2-user:ec2-user /home/ec2-user/create-tables.sql

echo "MySQL client setup completed. Use the connect-to-db.sh script to connect to your RDS instance."
EOF

  tags = {
    Name = "MySQL-Client-Instance"
  }
}
