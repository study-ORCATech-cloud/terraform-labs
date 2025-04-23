# LAB02: Deploy an Azure Storage Account for Blob Storage with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to provision an **Azure Storage Account** with **Blob Storage** enabled. You'll configure containers, access tiers, and optional static website hosting — all through Infrastructure as Code.

---

## 🎯 Objectives

- Create a general-purpose v2 storage account
- Configure a blob container with access control
- Enable static website hosting (optional)

---

## 🧰 Prerequisites

- Azure account with storage access
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB02-Storage-Account/
├── main.tf               # Storage account and blob container
├── variables.tf          # Name, region, tier, access level
├── outputs.tf            # Storage account name, container URL
├── terraform.tfvars      # Optional input values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform project**
```bash
terraform init
```

2. **Run the plan to preview infrastructure**
```bash
terraform plan
```

3. **Apply the configuration**
```bash
terraform apply
```

4. **Verify storage account and blob container** via Azure Portal or CLI

---

## 🧼 Cleanup

```bash
terraform destroy
```
Deletes the storage account and all associated blobs/containers.

---

## 💡 Key Concepts

- **Storage Account**: Base resource for storing blobs, files, queues, and tables
- **Blob Container**: Stores objects/files within a storage account
- **Access Tier**: Controls storage cost and availability (Hot, Cool, Archive)
- **Static Website Hosting**: Serve HTML/CSS from Azure Blob endpoint

---

## 🧪 Optional Challenges

- Upload a static website and enable access via HTTPS
- Use tags and lifecycle policies
- Create shared access tokens (SAS)

---

## 📚 References

- [Terraform AzureRM Storage Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
- [Azure Blob Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/)

---

## ✅ Summary

You've now created a scalable and secure Azure storage solution using Terraform. Blob storage is widely used in modern cloud-native architectures.

**Next up:** Create and manage Azure Active Directory users and groups in LAB03.