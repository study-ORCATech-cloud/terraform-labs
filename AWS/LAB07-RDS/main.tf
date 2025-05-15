# VPC and Networking
# TODO: Create a VPC for the RDS instance
# Requirements:
# - Set CIDR block from var.vpc_cidr
# - Enable DNS support and hostnames
# - Add appropriate tags
# HINT: Use the aws_vpc resource

# TODO: Create subnets in different availability zones for high availability
# Requirements:
# - Create two subnets in different AZs (${var.region}a and ${var.region}b)
# - Use var.subnet_cidr_1 and var.subnet_cidr_2 for CIDR blocks
# - Associate with the VPC you created
# - Add appropriate tags
# HINT: Use the aws_subnet resource

# TODO: Create an Internet Gateway
# Requirements:
# - Attach it to the VPC
# - Add appropriate tags
# HINT: Use the aws_internet_gateway resource

# TODO: Create a route table for public access
# Requirements:
# - Associate with the VPC
# - Add a route for 0.0.0.0/0 pointing to the Internet Gateway
# - Add appropriate tags
# HINT: Use the aws_route_table resource with a route block

# TODO: Associate the route table with the subnets
# Requirements:
# - Associate the route table with both subnets
# HINT: Use the aws_route_table_association resource

# Security Groups
# TODO: Create a security group for the RDS instance
# Requirements:
# - Name it "rds-security-group"
# - Allow MySQL traffic (port 3306) from the CIDR range in var.allowed_cidr
# - Allow all outbound traffic
# - Add appropriate tags
# HINT: Use the aws_security_group resource

# TODO: Create an EC2 security group for the client instance
# Requirements:
# - Name it "mysql-client-sg"
# - Allow SSH access (port 22) from anywhere for this lab
# - Allow all outbound traffic
# - Add appropriate tags
# HINT: Use the aws_security_group resource

# RDS Configuration
# TODO: Create a DB subnet group
# Requirements:
# - Name it "rds-subnet-group"
# - Include both subnets you created
# - Add appropriate tags
# HINT: Use the aws_db_subnet_group resource with subnet_ids

# TODO: Create a DB parameter group
# Requirements:
# - Name it "rds-mysql-params"
# - Use the "mysql8.0" family
# - Configure the following parameters:
#   - character_set_server = "utf8mb4"
#   - collation_server = "utf8mb4_general_ci"
#   - max_connections = "150"
#   - general_log = "1"
# - Add appropriate tags
# HINT: Use the aws_db_parameter_group resource with multiple parameter blocks

# TODO: Create an option group
# Requirements:
# - Name it "rds-mysql-options"
# - Set it up for MySQL 8.0
# - Add appropriate tags
# HINT: Use the aws_db_option_group resource

# TODO: Create the RDS instance
# Requirements:
# - Use var.db_identifier as the identifier
# - Set up MySQL 8.0 as the engine
# - Use var.db_instance_class for the instance class
# - Configure allocated storage from var.allocated_storage with gp2 storage type
# - Enable storage encryption
# - Set database name, username, and password from variables
# - Configure port 3306
# - Set publicly_accessible from var.publicly_accessible
# - Attach the security group you created
# - Use the subnet group, parameter group, and option group created above
# - Configure backups with retention period from var.backup_retention_period
# - Set backup window to "03:00-04:00" and maintenance window to "Mon:04:00-Mon:05:00"
# - Set multi_az from var.multi_az
# - Set skip_final_snapshot to true for lab purposes
# - Disable deletion protection for lab purposes
# - Enable CloudWatch log exports for error, general, and slowquery logs
# - Add appropriate tags
# HINT: Use the aws_db_instance resource

# TODO: Create an EC2 instance to use as a MySQL client
# Requirements:
# - Only create if var.create_client_instance is true (use count)
# - Use var.client_ami_id for the AMI
# - Use t2.micro for the instance type
# - Place it in the first subnet
# - Attach the client security group
# - Use var.key_name for SSH access
# - Enable public IP association
# - Add user data script that:
#   - Installs MySQL client
#   - Creates a connection script with the RDS endpoint details
#   - Creates a sample SQL script to create tables
# - Add appropriate tags
# HINT: Use the aws_instance resource with count and heredoc for user_data
