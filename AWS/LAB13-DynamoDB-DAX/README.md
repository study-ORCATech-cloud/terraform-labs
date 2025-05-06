# LAB13: AWS DynamoDB with DAX and Global Tables

## 📝 Lab Overview

In this lab, you'll use Terraform to set up a production-ready **Amazon DynamoDB** database with **DynamoDB Accelerator (DAX)** for in-memory caching. You'll also configure global tables for multi-region availability, implement fine-grained access control, and set up monitoring and auto-scaling.

---

## 🎯 Learning Objectives

- Deploy DynamoDB tables with proper key schema and indexes
- Configure DynamoDB Accelerator (DAX) for in-memory caching
- Set up DynamoDB Global Tables for multi-region replication
- Implement auto-scaling for read/write capacity
- Configure fine-grained access control with IAM
- Implement point-in-time recovery and on-demand backups
- Monitor DynamoDB performance with CloudWatch

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of NoSQL databases
- Completion of LAB03 (IAM) is recommended

---

## 📁 Lab Files

- `main.tf`: DynamoDB tables, DAX cluster, and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: DynamoDB endpoints and ARNs
- `terraform.tfvars`: Configuration values
- `iam-policies/`: Sample IAM policies for DynamoDB access
- `sample-data/`: Test data for DynamoDB tables

---

## 🔨 Lab Tasks

1. **Create DynamoDB Tables**:
   - Define tables with appropriate key schema
   - Configure secondary indexes for query optimization
   - Set up time-to-live (TTL) attributes

2. **Implement DynamoDB Auto-scaling**:
   - Configure auto-scaling for read/write capacity
   - Set up scaling targets and policies
   - Test scaling behavior

3. **Set up DynamoDB Accelerator (DAX)**:
   - Create a DAX cluster
   - Configure subnet groups and security
   - Connect application to DAX endpoint

4. **Configure Global Tables**:
   - Set up multi-region replication
   - Test failover and cross-region access
   - Measure replication latency

5. **Implement Backup and Recovery**:
   - Enable point-in-time recovery
   - Create on-demand backups
   - Test restore operations

6. **Configure IAM Policies**:
   - Create fine-grained access control policies
   - Set up condition-based access
   - Implement least privilege principles

7. **Set up Monitoring and Alerts**:
   - Configure CloudWatch metrics and alarms
   - Set up alerts for capacity constraints
   - Monitor consumed capacity and throttled requests

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional DynamoDB table with optimized schema
- DAX cluster for high-performance caching
- Global Tables set up for multi-region availability
- Auto-scaling configured for dynamic workloads
- Comprehensive monitoring and alerting
- Secure access control with fine-grained IAM policies

---

## 📚 Advanced Challenges

- Implement DynamoDB Streams with Lambda functions
- Create complex query patterns with GSI and LSI
- Set up DynamoDB as an event source for Lambda
- Implement composite key design patterns
- Create a serverless API using API Gateway and DynamoDB

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- DynamoDB tables
- DAX cluster
- Global Table replicas
- CloudWatch alarms
- IAM roles and policies
- Backups and snapshots

---

## 📖 Additional Resources

- [DynamoDB Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)
- [AWS DynamoDB Developer Guide](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)
- [DynamoDB Accelerator (DAX) Documentation](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DAX.html)
- [DynamoDB Global Tables](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GlobalTables.html)
- [Amazon DynamoDB Best Practices](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/best-practices.html) 