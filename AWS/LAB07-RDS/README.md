# LAB07: Provision a MySQL Database with Amazon RDS using Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Terraform** to provision an **Amazon RDS** instance running **MySQL 8.0**. You'll create a complete VPC environment with subnets across multiple availability zones, configure security groups, parameter groups, and set up automated backups. Optionally, you can deploy a client EC2 instance to test connectivity and run sample queries.

---

## 🎯 Learning Objectives

- Create a VPC with multiple subnets for RDS high availability
- Configure security groups and network access controls
- Deploy a MySQL 8.0 RDS instance with custom parameters
- Set up automated backups and maintenance windows
- Create a client instance for testing database connectivity
- Execute sample SQL queries against your database

---

## 🧰 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.3+ installed
- AWS CLI configured with access credentials
- SSH key pair (if creating a client instance for connectivity testing)
- Basic knowledge of SQL and database concepts

---

## 📁 Files Structure

```
AWS/LAB07-RDS/
├── main.tf                  # Primary configuration with TODO sections for students to implement
├── variables.tf             # Variable definitions for customization
├── outputs.tf               # Output values for connection details
├── providers.tf             # AWS provider configuration
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
├── solutions.md             # Solutions to the TODOs (for reference)
└── README.md                # This documentation file
```

---

## 🌐 RDS Architecture

This lab implements a database architecture with the following components:

1. **VPC**: A dedicated virtual private cloud with DNS settings enabled
2. **Subnets**: Two subnets in different availability zones for high availability
3. **Internet Gateway**: Provides internet access for the client instance
4. **Route Tables**: Control traffic flow between subnets and the internet
5. **Security Groups**: Control access to both the RDS instance and client EC2
6. **DB Subnet Group**: Defines which subnets RDS can use
7. **Parameter Group**: Custom MySQL configuration settings
8. **Option Group**: Engine-specific options for MySQL
9. **RDS Instance**: MySQL 8.0 database with encryption, backups, and monitoring
10. **Client Instance**: Optional EC2 instance to test database connectivity

All of these resources are deployed with proper security settings and best practices.

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB07-RDS
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure RDS Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Customize the configuration in `terraform.tfvars` to adjust:
   - VPC and subnet CIDR blocks
   - Database identifiers, credentials, and instance class
   - Storage settings and backup preferences
   - Multi-AZ and public accessibility options
   - Client instance creation settings

   > ⚠️ **Important**: For this lab, we use simple credentials, but in production environments, use strong passwords and restrict access.

### Step 4: Complete the TODO Sections

This lab contains several TODO sections in main.tf and outputs.tf that you need to complete:

1. In `main.tf`:

   a. **VPC and Networking**
      - Create a VPC with DNS support enabled
      - Create subnets in different availability zones
      - Configure Internet Gateway and route tables
      - Set up route table associations

   b. **Security Groups**
      - Create a security group for the RDS instance 
      - Create a security group for the client EC2 instance

   c. **RDS Configuration**
      - Create a DB subnet group spanning multiple availability zones
      - Set up a custom parameter group for MySQL 8.0
      - Configure an option group for additional database features

   d. **RDS Instance**
      - Deploy an RDS MySQL instance with appropriate settings
      - Configure backup retention, maintenance windows, and monitoring
      - Enable encryption and logging features

   e. **Client Instance**
      - Create an EC2 instance to connect to the database
      - Configure user data script to install MySQL client

2. In `outputs.tf`:
   - Define outputs for RDS endpoint, port, and credentials
   - Output subnet group and parameter group information
   - Create conditional outputs for client instance details
   - Define a connection string output for easy database access

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the resources to be created:
   - VPC with DNS settings enabled
   - Subnets in different availability zones
   - Internet Gateway and route tables
   - Security groups with appropriate rules
   - DB subnet group and parameter group
   - RDS MySQL instance with all configurations
   - Client EC2 instance (if enabled)

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, Terraform will display outputs including:
   - RDS endpoint and port
   - Database name and connection details
   - Client instance public IP (if created)

### Step 7: Test Database Connectivity

#### Option A: Using the Client Instance (If Created)

1. SSH into the client instance:
   ```bash
   ssh -i your-key.pem ec2-user@$(terraform output -raw client_instance_public_ip)
   ```

2. Use the pre-configured connection script:
   ```bash
   ./connect-to-db.sh
   ```

3. Run some test SQL queries:
   ```sql
   SHOW DATABASES;
   CREATE DATABASE test;
   USE test;
   CREATE TABLE sample (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100));
   INSERT INTO sample (name) VALUES ('Test Record');
   SELECT * FROM sample;
   ```

#### Option B: Using a Local MySQL Client

1. Install a MySQL client on your local machine if needed.

2. Use the connection string from the output:
   ```bash
   $(terraform output -raw connection_string)
   # When prompted, enter the password
   ```

---

## 🔍 Understanding the RDS Architecture

### Database Architecture Diagram

```
                                   Internet
                                      |
                                      | 
                               Internet Gateway
                                      |
                                      |
+---------------------------------------------------------------------+
|                                  VPC                                 |
|                                                                     |
|  +---------------------+            +---------------------+         |
|  |                     |            |                     |         |
|  |    Public Subnet    |            |    Public Subnet    |         |
|  |    10.0.1.0/24      |            |    10.0.2.0/24      |         |
|  |    (eu-west-1a)     |            |    (eu-west-1b)     |         |
|  |                     |            |                     |         |
|  +----------+----------+            +----------+----------+         |
|             |                                  |                    |
|             |                                  |                    |
|             |      +--------------------+      |                    |
|             |      |                    |      |                    |
|             +----->|  Client Instance   |<-----+                    |
|                    |  (MySQL Client)    |                           |
|                    |                    |                           |
|                    +--------------------+                           |
|                              |                                      |
|                              |                                      |
|                              v                                      |
|            +----------------------------------------+               |
|            |            Security Group              |               |
|            |                                        |               |
|            +----------------------------------------+               |
|                              |                                      |
|                              v                                      |
|  +---------------------+    |     +---------------------+          |
|  |                     |    |     |                     |          |
|  |     DB Subnet       |<---+---->|     DB Subnet       |          |
|  | (DB Subnet Group)   |          | (DB Subnet Group)   |          |
|  |                     |          |                     |          |
|  +----------+----------+          +----------+----------+          |
|             |                                |                     |
|             |                                |                     |
|             |     +--------------------+     |                     |
|             |     |                    |     |                     |
|             +---->| RDS MySQL Instance |<----+                     |
|                   |   (Primary/Replica)|                           |
|                   |                    |                           |
|                   +--------------------+                           |
|                                                                    |
+--------------------------------------------------------------------+
```

### Key Components Explained

1. **VPC**: A logically isolated network with a defined CIDR block
   ```hcl
   resource "aws_vpc" "rds_vpc" {
     cidr_block           = var.vpc_cidr
     enable_dns_support   = true
     enable_dns_hostnames = true
     # Tags...
   }
   ```

2. **Subnets**: Subdivisions of the VPC CIDR block in different AZs
   ```hcl
   resource "aws_subnet" "rds_subnet_1" {
     vpc_id            = aws_vpc.rds_vpc.id
     cidr_block        = var.subnet_cidr_1
     availability_zone = "${var.aws_region}a"
     # Tags...
   }
   ```

3. **Security Groups**: Control traffic to and from the RDS instance
   ```hcl
   resource "aws_security_group" "rds_sg" {
     vpc_id = aws_vpc.rds_vpc.id
     
     ingress {
       from_port   = 3306
       to_port     = 3306
       protocol    = "tcp"
       cidr_blocks = [var.allowed_cidr]
     }
     # Egress rules and tags...
   }
   ```

4. **DB Subnet Group**: A collection of subnets for database high availability
   ```hcl
   resource "aws_db_subnet_group" "rds_subnet_group" {
     name        = "${var.name_prefix}-rds-subnet-group"
     subnet_ids  = [aws_subnet.rds_subnet_1.id, aws_subnet.rds_subnet_2.id]
     # Tags...
   }
   ```

5. **Parameter Group**: Custom configuration for MySQL database
   ```hcl
   resource "aws_db_parameter_group" "rds_param_group" {
     name   = "${var.name_prefix}-rds-mysql-params"
     family = "mysql8.0"
     
     parameter {
       name  = "character_set_server"
       value = "utf8mb4"
     }
     # Other parameters and tags...
   }
   ```

6. **RDS Instance**: The actual MySQL database server
   ```hcl
   resource "aws_db_instance" "mysql_db" {
     identifier              = "${var.name_prefix}-${var.db_identifier}"
     engine                  = "mysql"
     engine_version          = "8.0"
     instance_class          = var.db_instance_class
     allocated_storage       = var.allocated_storage
     storage_type            = "gp2"
     storage_encrypted       = true
     # Other configuration settings...
   }
   ```

---

## 💡 Key Learning Points

1. **Database Design Principles**:
   - Multi-AZ deployment for high availability
   - Subnet isolation for database security
   - Parameter groups for database customization
   - Backup and recovery strategy implementation

2. **RDS Configuration Concepts**:
   - Choosing appropriate instance classes and storage
   - Configuring maintenance windows and backup retention
   - Setting up database parameter groups
   - Implementing encryption for data at rest

3. **Terraform Techniques**:
   - Conditional resource creation with count
   - User data scripts for EC2 instance configuration
   - Resource dependencies in database deployments
   - Creating and managing sensitive outputs

4. **AWS Database Best Practices**:
   - Using private subnets for database instances
   - Configuring proper security groups and access controls
   - Setting up automated backups and maintenance
   - Implementing database logging and monitoring

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Enable Multi-AZ Deployment**:
   Change the configuration to enable high availability with a standby replica
   ```hcl
   resource "aws_db_instance" "mysql_db" {
     # Existing configuration...
     multi_az = true
   }
   ```

2. **Add Read Replicas**:
   Create a read replica for scaling read operations
   ```hcl
   resource "aws_db_instance" "read_replica" {
     replicate_source_db = aws_db_instance.mysql_db.id
     instance_class      = var.db_instance_class
     publicly_accessible = false
     skip_final_snapshot = true
     parameter_group_name = aws_db_parameter_group.rds_param_group.name
     # Other settings...
   }
   ```

3. **Implement Enhanced Monitoring**:
   Enable detailed monitoring for your RDS instance
   ```hcl
   resource "aws_db_instance" "mysql_db" {
     # Existing configuration...
     monitoring_interval = 30
     monitoring_role_arn = aws_iam_role.rds_monitoring_role.arn
   }
   
   resource "aws_iam_role" "rds_monitoring_role" {
     name = "${var.name_prefix}-rds-monitoring-role"
     assume_role_policy = jsonencode({
       Version = "2012-10-17"
       Statement = [{
         Action = "sts:AssumeRole"
         Effect = "Allow"
         Principal = {
           Service = "monitoring.rds.amazonaws.com"
         }
       }]
     })
   }
   ```

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. First, check for any dependent resources that might be using the RDS instance:
   ```bash
   # If you created any snapshots
   aws rds describe-db-snapshots --db-instance-identifier $(terraform output -raw rds_db_identifier)
   
   # If you created any read replicas
   aws rds describe-db-instances --query "DBInstances[?ReadReplicaSourceDBInstanceIdentifier=='$(terraform output -raw rds_db_identifier)']"
   ```

2. When ready, destroy the infrastructure:
   ```bash
   terraform destroy
   ```

3. Type `yes` when prompted to confirm.

4. Verify that all resources have been deleted:
   ```bash
   # Check if the RDS instance still exists
   aws rds describe-db-instances --db-instance-identifier $(terraform output -raw rds_db_identifier) 2>/dev/null || echo "RDS instance has been deleted"
   
   # Check if the VPC still exists
   aws ec2 describe-vpcs --vpc-id $(terraform output -raw rds_vpc_id) 2>/dev/null || echo "VPC has been deleted"
   ```

5. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars
   ```

> ⚠️ **Important Note**: RDS instances continue to incur costs until they are completely deleted. Make sure to finish the destroy process even if it takes some time.

---

## 🚫 Common Errors and Troubleshooting

1. **DB Instance Already Exists**:
   ```
   Error: Error creating DB Instance: DBInstanceAlreadyExists
   ```
   **Solution**: Choose a different identifier or wait for the previous instance to be fully deleted (which can take up to 10 minutes).

2. **Insufficient Instance Capacity**:
   ```
   Error: Error creating DB Instance: InsufficientDBInstanceCapacity
   ```
   **Solution**: Choose a different instance class or a different Availability Zone.

3. **Parameter Group Not Found**:
   ```
   Error: Error modifying DB Instance: DBParameterGroupNotFound
   ```
   **Solution**: Ensure the parameter group is created before the RDS instance or check name typos.

4. **Subnet Group Error**:
   ```
   Error: Error creating DB Instance: DBSubnetGroupDoesNotCoverEnoughAZs
   ```
   **Solution**: Ensure your subnet group has subnets in at least two different Availability Zones.

5. **Connectivity Issues**:
   ```
   ERROR 2003 (HY000): Can't connect to MySQL server
   ```
   **Solution**: Check security groups, route tables, and network ACLs. Ensure the client has the correct endpoint.

6. **Password Issues**:
   ```
   Access denied for user 'admin'@'%' (using password: YES)
   ```
   **Solution**: Verify the password in terraform.tfvars matches what you're using to connect.

---

## 📚 Additional Resources

- [Amazon RDS User Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)
- [RDS for MySQL Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html)
- [Terraform AWS Provider - RDS Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [AWS Database Blog](https://aws.amazon.com/blogs/database/)
- [RDS Parameter Group Reference](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.MySQL.Parameters.html)

---

## 🚀 Next Lab

Proceed to [LAB08-S3-Lifecycle](../LAB08-S3-Lifecycle/) to learn how to implement storage lifecycle management and versioning policies with Amazon S3.

---

Happy Terraforming!