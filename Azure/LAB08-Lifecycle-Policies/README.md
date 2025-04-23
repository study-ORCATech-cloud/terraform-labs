# LAB08: Manage Blob Lifecycle with Azure Storage Policies using Terraform

## 📝 Lab Overview

In this lab, you'll automate **blob storage management** by configuring **lifecycle rules** and **retention policies** in Azure Storage using **Terraform**. This helps enforce cost-efficient, automated data cleanup.

---

## 🎯 Objectives

- Create lifecycle rules to delete or archive blobs
- Define filters for blob age, access, or name
- Attach rules to specific containers or tags

---

## 🧰 Prerequisites

- Azure account with access to Storage resource provider
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB08-Lifecycle-Policies/
├── main.tf               # Storage account + lifecycle policies
├── variables.tf          # Rules, tag filters, account name
├── outputs.tf            # Policy IDs and status
├── terraform.tfvars      # Optional inputs
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Deploy storage account and rule**
```bash
terraform init
terraform plan
terraform apply
```

2. **Upload test blobs** to trigger lifecycle rule

3. **Check rule application** using Azure Portal or CLI logs

---

## 🧼 Cleanup

```bash
terraform destroy
```
This will delete the policy and container

---

## 💡 Key Concepts

- **Lifecycle Rule**: Controls blob transition or deletion based on conditions
- **Filter Prefix/Tag**: Target specific files or categories
- **Blob Access Tier**: Transition between Hot, Cool, Archive

---

## 🧪 Optional Challenges

- Apply different policies to separate containers
- Combine date-based and tag-based conditions
- Use container-level immutability (advanced)

---

## 📚 References

- [Terraform Azure Storage Lifecycle Rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy)
- [Azure Lifecycle Docs](https://learn.microsoft.com/en-us/azure/storage/blobs/lifecycle-management-overview)

---

## ✅ Summary

You’ve now created automated storage lifecycle rules in Azure using Terraform — a key strategy for cost control and compliance.

**Next up:** Register and map custom domains using Azure DNS in LAB09.

