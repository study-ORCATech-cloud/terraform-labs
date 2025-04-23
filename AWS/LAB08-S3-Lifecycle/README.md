# LAB08: Apply Lifecycle Rules and Versioning to S3 Buckets with Terraform

## 📝 Lab Overview

In this lab, you'll enhance your **S3 bucket** configuration by applying **object versioning** and **lifecycle policies** using **Terraform**. These features are essential for data protection and cost optimization.

---

## 🎯 Objectives

- Enable object versioning on a bucket
- Add lifecycle policies to delete or transition objects
- Manage these features using Terraform infrastructure as code

---

## 🧰 Prerequisites

- AWS account with S3 permissions
- Terraform v1.3+ installed

---

## 📁 File Structure

```bash
AWS/LAB08-S3-Lifecycle/
├── main.tf               # S3 bucket and lifecycle config
├── variables.tf          # Bucket name, rules, etc.
├── outputs.tf            # Bucket info, rules applied
├── terraform.tfvars      # Optional variable values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
   ```bash
   terraform init
   ```
2. **Plan and apply the configuration**
   ```bash
   terraform plan
   terraform apply
   ```
3. **Upload sample files and test transitions** via AWS Console

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure no critical data remains before deletion.

---

## 💡 Key Concepts

- **Versioning**: Preserves, retrieves, and restores every object version
- **Lifecycle Rules**: Transition or delete objects after a defined age
- **Cost Optimization**: Move rarely accessed objects to cold storage

---

## 🧪 Optional Challenges

- Transition objects to Glacier after 30 days
- Add tags and restrict rules to certain tags
- Set up event notification for deletions

---

## 📚 References

- [Terraform S3 Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [AWS Lifecycle Policies](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)

---

## ✅ Summary

You've now enhanced an S3 bucket with lifecycle rules and versioning — all using Terraform. This ensures data resilience and reduces costs in long-term storage.

**Next up:** Route traffic using custom domains with Route 53 in LAB09.