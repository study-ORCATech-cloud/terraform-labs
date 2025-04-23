# LAB03: Manage IAM Roles and Service Accounts in GCP using Terraform

## 📝 Lab Overview

In this lab, you'll define and assign **IAM roles** and create **service accounts** using **Terraform** in GCP. These concepts are essential for secure, controlled access to cloud resources.

---

## 🎯 Objectives

- Create custom IAM roles (or assign predefined ones)
- Create and bind service accounts to roles
- Use Terraform to enforce least privilege principles

---

## 🧰 Prerequisites

- GCP project with IAM permissions
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB03-IAM-Roles/
├── main.tf               # IAM role and service account setup
├── variables.tf          # Role ID, SA name, project ID
├── outputs.tf            # Email of SA, IAM bindings
├── terraform.tfvars      # Input overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
```bash
terraform init
```

2. **Apply configuration**
```bash
terraform apply
```

3. **Inspect service account in GCP Console**

---

## 🧼 Cleanup

```bash
terraform destroy
```
Removes custom roles and service accounts

---

## 💡 Key Concepts

- **IAM Role**: Permission set assigned to users or SAs
- **Service Account**: Identity for automated workloads
- **IAM Binding**: Associates a principal with a role and scope

---

## 🧪 Optional Challenges

- Assign logging or storage viewer permissions
- Restrict service account key creation
- Use a custom JSON policy definition

---

## 📚 References

- [Terraform IAM Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam_member)
- [GCP IAM Overview](https://cloud.google.com/iam/docs/overview)

---

## ✅ Summary

You’ve now implemented GCP IAM roles and service accounts using Terraform, enabling secure, controlled, and scalable cloud environments.

**Next up:** Configure custom networking with VPCs and firewalls in LAB04.

