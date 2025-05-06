# LAB17: AWS Aurora Serverless with Terraform

## 📝 Lab Overview

In this lab, you'll use Terraform to deploy and configure **Amazon Aurora Serverless v2** database clusters. You'll learn how to set up a serverless relational database that scales automatically based on demand, implement high availability, configure data API access, and set up monitoring and backup strategies.

---

## 🎯 Learning Objectives

- Deploy an Aurora Serverless v2 cluster using Terraform
- Configure auto-scaling capacity settings
- Implement high availability with multi-AZ deployments
- Set up Data API for serverless access patterns
- Configure secure networking with VPC and security groups
- Implement database encryption and parameter groups
- Set up automated backups and point-in-time recovery
- Create alarms and monitoring for database performance

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of relational databases
- Familiarity with SQL
- Completion of LAB04 (VPC) and LAB07 (RDS) recommended

---

## 📁 Lab Files

- `main.tf`: Aurora Serverless cluster and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: Cluster endpoints and connection details
- `terraform.tfvars`: Configuration values
- `sql/`: SQL scripts for database initialization
- `lambda/`: Sample Lambda functions for Data API access

---

## 🔨 Lab Tasks

1. **Create Aurora Serverless v2 Cluster**:
   - Configure cluster parameters and engine version
   - Set up database credentials securely
   - Configure auto-scaling capacity units
   - Set up subnet groups and parameter groups

2. **Implement Secure Networking**:
   - Create VPC security groups for database access
   - Configure private subnets for the database cluster
   - Set up route tables and network ACLs
   - Implement VPC endpoints for secure access

3. **Configure Data API Access**:
   - Enable Data API for serverless access
   - Create IAM policies for secure access
   - Set up Lambda functions to access the database
   - Test SQL queries via Data API

4. **Implement High Availability**:
   - Configure multi-AZ deployments
   - Set up read replicas
   - Test failover scenarios
   - Configure connection timeouts and retry logic

5. **Set up Monitoring and Alerting**:
   - Create CloudWatch alarms for database metrics
   - Configure Enhanced Monitoring
   - Set up Performance Insights
   - Create dashboard for database performance

6. **Configure Backup and Recovery**:
   - Set up automated backup schedules
   - Configure backup retention periods
   - Test point-in-time recovery
   - Export snapshots to S3

7. **Implement Database Security**:
   - Enable encryption at rest with KMS
   - Configure IAM authentication
   - Set up audit logging
   - Implement SQL injection protection

8. **Test Performance and Scaling**:
   - Generate test workloads
   - Monitor auto-scaling behavior
   - Optimize for performance
   - Analyze cost implications

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional Aurora Serverless v2 database
- Auto-scaling configuration based on workload
- High availability across multiple Availability Zones
- Secure access via Data API and standard endpoints
- Comprehensive monitoring and logging
- Automated backup and recovery capabilities
- Cost-efficient database operations

---

## 📚 Advanced Challenges

- Implement blue/green deployments with Aurora
- Set up cross-region read replicas
- Configure database cloning for development environments
- Implement fine-grained access control with IAM
- Create event notifications for database changes

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- Aurora Serverless cluster
- DB subnet groups
- Parameter groups
- Security groups
- CloudWatch alarms and dashboards
- IAM roles and policies
- Automated backups and snapshots

---

## 📖 Additional Resources

- [Aurora Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster)
- [AWS Aurora Serverless v2 Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless-v2.html)
- [Aurora Data API Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/data-api.html)
- [Best Practices for Amazon Aurora](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.BestPractices.html)
- [Performance Best Practices for Amazon Aurora MySQL](https://d1.awsstatic.com/whitepapers/performance-best-practices-for-aurora-mysql.pdf) 