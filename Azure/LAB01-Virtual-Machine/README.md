# LAB01: Deploy a Virtual Machine with Azure CLI and Terraform

## 📝 Lab Overview

In this lab, you'll provision a **Virtual Machine** in **Microsoft Azure** using **Terraform**. You'll define the networking environment, VM size, operating system, and SSH key access to automate infrastructure setup.

---

## 🎯 Objectives

- Configure Azure Provider and authenticate
- Deploy a Linux VM with SSH access
- Create supporting resources: resource group, network, subnet, and NIC

---

## 🧰 Prerequisites

- Azure account with contributor permissions
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB01-Virtual-Machine/
├── main.tf               # VM, NIC, subnet, network resources
├── variables.tf          # VM size, name, region, etc.
├── outputs.tf            # VM public IP, admin user, etc.
├── terraform.tfvars      # Input variable values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize the configuration**
```bash
terraform init
```

2. **Validate and plan deployment**
```bash
terraform validate
terraform plan
```

3. **Apply to deploy VM**
```bash
terraform apply
```

4. **SSH into the VM** using the output IP address
```bash
ssh azureuser@<public-ip>
```

---

## 🧼 Cleanup

To avoid ongoing costs:
```bash
terraform destroy
```

---

## 💡 Key Concepts

- **Resource Group**: Logical container for Azure resources
- **Virtual Network/Subnet**: Define internal IP ranges and isolation
- **Network Interface**: Bridge between VM and virtual network
- **Public IP**: Allows external SSH or HTTP access

---

## 🧪 Optional Challenges

- Create multiple VMs using `count`
- Add Network Security Group (NSG) to restrict SSH to your IP
- Change VM image to Windows and access via RDP

---

## 📚 References

- [Terraform Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure VM Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/)

---

## ✅ Summary

You've successfully created a virtual machine and supporting infrastructure in Azure using Terraform. This foundational setup is critical for almost all cloud-based deployments.

**Next up:** Create and configure a blob storage account in LAB02.