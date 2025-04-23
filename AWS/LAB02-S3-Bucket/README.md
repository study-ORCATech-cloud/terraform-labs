# LAB02: Create and Manage an S3 Bucket with Terraform

## 📝 Lab Overview

In this lab, you’ll use **Terraform** to create and manage an **Amazon S3 bucket**. You'll apply bucket policies, configure versioning, and optionally host a static website — all through infrastructure as code.

---

## 🎯 Objectives

- Create an S3 bucket using Terraform
- Enable versioning for data protection
- Apply bucket policy to allow public or restricted access
- Optionally enable static website hosting

---

## 🧰 Prerequisites

- AWS account with IAM access
- Terraform v1.3+ installed and configured

---

## 📁 File Structure

```bash
AWS/LAB02-S3-Bucket/
├── main.tf              # Terraform configuration for the bucket
├── variables.tf         # Input variables
├── outputs.tf           # Outputs like bucket name or website URL
├── terraform.tfvars     # Example variable values (optional)
└── README.md            # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Preview the execution plan**
   ```bash
   terraform plan
   ```

3. **Create the bucket**
   ```bash
   terraform apply
   ```

4. **Inspect Outputs**
   ```bash
   terraform output
   ```

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure the bucket is empty before destruction to avoid errors.

---

## 💡 Key Concepts

- **aws_s3_bucket**: Core resource to define the bucket
- **Versioning**: Protects against accidental overwrites or deletions
- **Policy**: Allows you to control access (public, IAM-based, etc.)
- **Static Website**: Enable website hosting and define `index.html`

---

## 🧪 Optional Challenges

- Add a lifecycle rule to archive or delete objects after 30 days
- Enable logging to track access
- Deploy a simple HTML site with public access

---

## 📚 References

- [Terraform S3 Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [S3 Official Docs](https://docs.aws.amazon.com/s3/)

---

## ✅ Summary

You’ve successfully used Terraform to create and configure an S3 bucket. This is a key component in many cloud architectures and automation pipelines.

**Next up:** Manage IAM roles and policies in LAB03.