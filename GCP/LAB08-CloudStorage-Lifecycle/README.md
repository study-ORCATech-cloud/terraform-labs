# LAB08: Apply Object Lifecycle Management in Cloud Storage with Terraform

## 📝 Lab Overview

In this lab, you’ll configure **lifecycle policies** for **Cloud Storage buckets** using **Terraform**. You’ll enforce data retention and automated cleanup to optimize storage costs.

---

## 🎯 Objectives

- Enable object lifecycle rules (transition or deletion)
- Filter policies by object age or storage class
- Apply configuration across different buckets

---

## 🧰 Prerequisites

- GCP project with Storage Admin role
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB08-CloudStorage-Lifecycle/
├── main.tf               # Bucket + lifecycle rules
├── variables.tf          # Rule criteria, prefix filter
├── outputs.tf            # Bucket info, lifecycle config
├── terraform.tfvars      # Optional settings
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and apply configuration**
```bash
terraform init
terraform apply
```

2. **Upload objects** via `gsutil cp` or Console
3. **Review rules** in Console > Bucket > Lifecycle

---

## 🧼 Cleanup

```bash
terraform destroy
```
Make sure bucket is empty before destroying

---

## 💡 Key Concepts

- **Lifecycle Rule**: Defines actions (delete, change class)
- **Filter Prefix**: Applies rule to objects with certain names
- **Action Days**: Triggers actions after age threshold

---

## 🧪 Optional Challenges

- Combine delete and transition rules
- Retain newer versions of files (if versioning enabled)
- Add audit log sink to log lifecycle actions

---

## 📚 References

- [Terraform Lifecycle Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
- [GCP Lifecycle Guide](https://cloud.google.com/storage/docs/lifecycle)

---

## ✅ Summary

You’ve now automated object lifecycle management in GCP Cloud Storage using Terraform — a cost-saving best practice for large datasets.

**Next up:** Configure DNS and domain routing using GCP Cloud DNS in LAB09.