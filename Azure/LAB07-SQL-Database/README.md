# LAB07: Provision Azure SQL Database with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to provision an **Azure SQL Database** along with its supporting infrastructure. You’ll configure access policies, firewalls, and database settings for secure and scalable data storage.

---

## 🎯 Objectives

- Create an Azure SQL Server and database
- Configure firewall rules for allowed IPs
- Enable basic performance and backup features

---

## 🧰 Prerequisites

- Azure subscription with Database Contributor access
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB07-SQL-Database/
├── main.tf               # SQL Server, DB, firewall config
├── variables.tf          # DB name, credentials, IP whitelist
├── outputs.tf            # Connection strings, server name
├── terraform.tfvars      # Optional user input
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and configure Terraform**
```bash
terraform init
terraform plan
terraform apply
```

2. **Access the SQL database** via connection string (e.g., Data Studio, Azure CLI)

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure no critical data is stored in the database before destruction

---

## 💡 Key Concepts

- **SQL Server**: Logical container for one or more databases
- **Firewall Rules**: Allow public or IP-specific access
- **Elastic Pools**: (optional) Share compute resources
- **Geo-replication**: (advanced) Cross-region failover

---

## 🧪 Optional Challenges

- Enable Transparent Data Encryption (TDE)
- Use Active Directory authentication
- Connect via private endpoint

---

## 📚 References

- [Terraform Azure SQL Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database)
- [Azure SQL Overview](https://learn.microsoft.com/en-us/azure/azure-sql/)

---

## ✅ Summary

You’ve now provisioned a secure, managed SQL database using Terraform, perfect for use in production or learning environments.

**Next up:** Automate blob archival with lifecycle policies in LAB08.