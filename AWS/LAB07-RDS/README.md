# LAB07: Provision a MySQL Database with Amazon RDS using Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to provision an **Amazon RDS** instance running **MySQL**. You'll also configure subnet groups, security groups, and backup settings for high availability.

---

## 🎯 Objectives

- Launch a MySQL RDS instance using Terraform
- Configure DB subnet group and security group
- Enable automatic backups and retention

---

## 🧰 Prerequisites

- VPC and subnets from LAB04
- Terraform v1.3+ installed
- Basic knowledge of databases (MySQL syntax)

---

## 📁 File Structure

```bash
AWS/LAB07-RDS/
├── main.tf               # Terraform RDS and networking resources
├── variables.tf          # Inputs for DB name, username, etc.
├── outputs.tf            # Endpoint, port, etc.
├── terraform.tfvars      # Optional input values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Configure Terraform variables** for DB name, username, password
2. **Initialize Terraform**
   ```bash
   terraform init
   ```
3. **Plan and apply**
   ```bash
   terraform plan
   terraform apply
   ```
4. **Test the DB connection** using MySQL client

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure no data is needed from the DB before destroying.

---

## 💡 Key Concepts

- **RDS Instance**: Managed database service for MySQL
- **DB Subnet Group**: Specifies which subnets the DB can use
- **Backup and Retention**: Automated snapshots and recovery
- **Security Group**: Controls access to the database

---

## 🧪 Optional Challenges

- Enable multi-AZ deployment
- Add CloudWatch metrics and alarms for storage or CPU
- Add encryption at rest and in transit

---

## 📚 References

- [Terraform RDS Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [Amazon RDS MySQL Guide](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html)

---

## ✅ Summary

You've deployed a MySQL RDS instance using Terraform, with a secure and fault-tolerant setup. This is a vital skill for data-driven application infrastructure.

**Next up:** Explore lifecycle management and S3 versioning in LAB08.