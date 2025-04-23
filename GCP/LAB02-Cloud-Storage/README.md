# LAB02: Create a Cloud Storage Bucket with Terraform

## 📝 Lab Overview

In this lab, you’ll provision a **Cloud Storage bucket** in **GCP** using **Terraform**. You'll configure location, access control, and optional static website hosting — a key building block in cloud-native applications.

---

## 🎯 Objectives

- Create a Cloud Storage bucket with Terraform
- Set location, class, and access permissions
- Enable object versioning or static website (optional)

---

## 🧰 Prerequisites

- GCP project with billing enabled
- Terraform v1.3+ and Google provider configured

---

## 📁 File Structure

```bash
GCP/LAB02-Cloud-Storage/
├── main.tf               # Bucket configuration
├── variables.tf          # Bucket name, location, versioning
├── outputs.tf            # Bucket URL, name
├── terraform.tfvars      # Optional overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
```bash
terraform init
```

2. **Apply the configuration**
```bash
terraform apply
```

3. **Access the bucket via Console or CLI**
```bash
gsutil ls -p YOUR_PROJECT_ID
```

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure the bucket is empty before deletion

---

## 💡 Key Concepts

- **Bucket Location**: Region or multi-region
- **Storage Class**: Standard, Nearline, Coldline, Archive
- **Access Control**: Uniform or fine-grained

---

## 🧪 Optional Challenges

- Enable static website hosting and upload `index.html`
- Configure retention policies
- Add IAM permissions for other users or service accounts

---

## 📚 References

- [Terraform GCS Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
- [GCP Cloud Storage Docs](https://cloud.google.com/storage/docs)

---

## ✅ Summary

You’ve now provisioned a GCP Cloud Storage bucket using Terraform. This forms the backbone for data hosting, analytics, and static site deployments.

**Next up:** Manage IAM roles and service accounts in LAB03.

