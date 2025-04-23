# LAB07: Deploy a Cloud SQL PostgreSQL Instance with Terraform

## 📝 Lab Overview

In this lab, you’ll use **Terraform** to provision a **Cloud SQL** instance running **PostgreSQL** on GCP. You’ll configure networking, user credentials, and database settings for managed storage.

---

## 🎯 Objectives

- Create a PostgreSQL Cloud SQL instance
- Set database parameters and access configuration
- Enable private IP or public IP access (with authorized networks)

---

## 🧰 Prerequisites

- GCP project with Cloud SQL Admin role
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB07-CloudSQL/
├── main.tf               # SQL instance, DB user, and network
├── variables.tf          # DB name, region, tier, IP config
├── outputs.tf            # Connection name, public IP
├── terraform.tfvars      # Optional input values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and deploy**
```bash
terraform init
terraform apply
```

2. **Connect to DB** using public IP and user credentials (psql or GUI)

---

## 🧼 Cleanup

```bash
terraform destroy
```
Deletes SQL instance and network configuration

---

## 💡 Key Concepts

- **Cloud SQL**: Fully managed database service
- **Tier and Storage**: Define performance and size
- **Authorized Networks**: Limit access by IP

---

## 🧪 Optional Challenges

- Enable automated backups and failover
- Use private IP with VPC peering
- Add read replica for scale-out

---

## 📚 References

- [Terraform Cloud SQL Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)
- [GCP Cloud SQL Overview](https://cloud.google.com/sql/docs)

---

## ✅ Summary

You’ve now deployed a secure and scalable PostgreSQL instance using Terraform and GCP Cloud SQL. This is foundational for building modern data-driven applications.

**Next up:** Manage object lifecycle and retention in Cloud Storage in LAB08.