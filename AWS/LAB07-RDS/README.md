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
├── main.tf          # Primary configuration for RDS and networking resources
├── variables.tf     # Variable definitions for customization
├── outputs.tf       # Output values for connection details
├── terraform.tfvars # Variable values configuration
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

### 2. Deploy Your RDS Environment

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

### 3. Connect to Your MySQL Database

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

- **VPC**: Dedicated VPC for database resources
- **Subnets**: Multiple subnets across availability zones for redundancy
- **Route Tables**: Network routing configuration for database access
- **Security Groups**: Firewall rules controlling access to the database

### RDS Configuration

- **DB Instance**: MySQL 8.0 database server
- **Parameter Group**: Custom MySQL configuration parameters
- **Option Group**: Engine-specific options
- **Subnet Group**: Specifies which subnets the database can use
- **Security Configuration**: Network access controls and encryption settings

### Backup and Maintenance

- **Automated Backups**: Daily backups with 7-day retention
- **Maintenance Window**: Scheduled time for updates and patches
- **Point-in-Time Recovery**: Ability to restore to any point within the retention period

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

- Deploy and configure MySQL RDS instances using Terraform
- Implement best practices for database security and performance
- Set up proper networking for database access
- Configure automated backups and maintenance
- Test and validate database connectivity
- Manage database resources through infrastructure as code