# LAB07: Provision a MySQL Database with Amazon RDS using Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Terraform** to provision an **Amazon RDS** instance running **MySQL 8.0**. You'll create a complete VPC environment with subnets across multiple availability zones, configure security groups, parameter groups, and set up automated backups. Optionally, you can deploy a client EC2 instance to test connectivity and run sample queries.

---

## 🎯 Objectives

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

## 📁 File Structure

```bash
AWS/LAB07-RDS/
├── main.tf          # Primary configuration with TODO sections for students to implement
├── variables.tf     # Variable definitions for customization
├── outputs.tf       # Output values for connection details
├── terraform.tfvars # Variable values configuration
├── solutions.md     # Solutions to the TODOs (for reference)
└── README.md        # This documentation file
```

---

## 🚀 Steps to Complete the Lab

### 1. Prepare Your Environment

1. **Review and customize the terraform.tfvars file**
   - Set your preferred region (default: eu-west-1)
   - Configure your database credentials
   - Set storage, instance class, and backup preferences
   - Specify your SSH key pair name (if creating a client instance)

### 2. Complete the TODO Sections in main.tf

The `main.tf` file contains several TODO sections that you need to implement:

1. **VPC and Networking**
   - Create a VPC with DNS support enabled
   - Create subnets in different availability zones
   - Configure Internet Gateway and route tables
   - Set up route table associations

2. **Security Groups**
   - Create a security group for the RDS instance allowing MySQL traffic
   - Create a security group for the client EC2 instance allowing SSH access

3. **RDS Configuration**
   - Create a DB subnet group spanning multiple availability zones
   - Set up a custom parameter group for MySQL 8.0
   - Configure an option group for additional database features

4. **RDS Instance**
   - Deploy an RDS MySQL instance with appropriate settings
   - Configure backup retention, maintenance windows, and monitoring
   - Enable encryption and logging features

5. **Client Instance**
   - Create an EC2 instance to connect to the database
   - Configure user data script to install MySQL client and setup tools
   - Create sample SQL scripts for testing

Each TODO section includes specific requirements and hints to help you implement the solution.

### 3. Deploy Your RDS Environment

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review the deployment plan**
   ```bash
   terraform plan
   ```

3. **Apply the configuration**
   ```bash
   terraform apply
   ```

4. **Record the outputs**
   - RDS endpoint and port
   - Database name and connection details
   - Client instance public IP (if created)

### 4. Connect to Your MySQL Database

#### Option A: Using the Client Instance (If Created)

1. **SSH into the client instance**
   ```bash
   ssh -i your-key.pem ec2-user@<client_instance_public_ip>
   ```

2. **Use the pre-configured connection script**
   ```bash
   ./connect-to-db.sh
   ```

3. **Run the sample SQL script**
   ```bash
   mysql -h <rds_endpoint> -P 3306 -u admin -p labdb < create-tables.sql
   ```

#### Option B: Using a Local MySQL Client

1. **Install a MySQL client on your local machine**
   - For Windows: MySQL Workbench or command-line client
   - For macOS: `brew install mysql-client`
   - For Linux: `apt-get install mysql-client` or equivalent

2. **Connect to your RDS instance**
   ```bash
   mysql -h <rds_endpoint> -P 3306 -u admin -p labdb
   ```

3. **Create a test table and insert data**
   ```sql
   CREATE TABLE test_table (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100));
   INSERT INTO test_table (name) VALUES ('Test Record');
   SELECT * FROM test_table;
   ```

---

## 🔍 Key Components

### VPC Configuration

The lab will have you create:
- **VPC**: Dedicated VPC for database resources with DNS support
- **Subnets**: Multiple subnets across availability zones for redundancy
- **Route Tables**: Network routing configuration for database access
- **Security Groups**: Firewall rules controlling access to the database

### RDS Configuration

You'll need to implement:
- **DB Instance**: MySQL 8.0 database server with appropriate settings
- **Parameter Group**: Custom MySQL configuration parameters for optimization
- **Option Group**: Engine-specific options for MySQL
- **Subnet Group**: Specifies which subnets the database can use
- **Security Configuration**: Network access controls and encryption settings

### Backup and Maintenance

Your implementation should include:
- **Automated Backups**: Daily backups with configurable retention
- **Maintenance Window**: Scheduled time for updates and patches
- **Monitoring**: CloudWatch integration for database metrics

### Client Instance

If enabled, you'll create:
- **EC2 Instance**: A MySQL client instance for connectivity testing
- **Connection Scripts**: Automation scripts to connect to the database
- **Sample Queries**: SQL scripts to test database functionality

---

## 🚨 Security Considerations

- The lab uses default credentials for simplicity. In a production environment:
  - Use strong, unique passwords
  - Restrict network access to specific IP ranges or VPCs
  - Enable encryption for data at rest and in transit
  - Consider using AWS Secrets Manager for credential management
  - Use IAM authentication for database access

---

## 🧼 Cleanup

When you've completed the lab, destroy all resources to avoid incurring additional costs:

```bash
terraform destroy
```

**Note**: This will delete the RDS instance and all associated data. Make sure you've exported any important data before running this command.

---

## 💡 Advanced Extensions

Take your learning further by trying these advanced enhancements:

1. **Enable Multi-AZ Deployment**
   - Set `multi_az = true` in terraform.tfvars for high availability

2. **Configure Enhanced Monitoring**
   - Decrease the monitoring interval for more frequent metrics
   - Add CloudWatch alarms for key performance indicators

3. **Implement Performance Insights**
   - Enable performance insights to analyze database performance
   - Create custom dashboards for monitoring

4. **Add Read Replicas**
   - Create read replicas for scaling read operations
   - Test load balancing between primary and replica instances

5. **Implement IAM Authentication**
   - Configure IAM database authentication
   - Use IAM roles instead of password authentication

---

## 📚 References

- [Amazon RDS Documentation](https://docs.aws.amazon.com/rds/index.html)
- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [Terraform AWS Provider - RDS Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [RDS Parameter Group Reference](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.MySQL.Parameters.html)
- [AWS Database Blog](https://aws.amazon.com/blogs/database/)

---

## ✅ Key Takeaways

After completing this lab, you'll understand how to:

- Design and implement a highly available database environment
- Configure MySQL RDS instances with proper security and performance settings
- Set up automated backup and maintenance strategies
- Use Terraform to automate database infrastructure provisioning
- Test and verify database connectivity and functionality
- Apply database best practices in a cloud environment