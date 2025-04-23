# LAB04: Build Virtual Network with Subnets and NSGs using Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to create a secure and scalable **Azure Virtual Network (VNet)**. You'll add subnets, **Network Security Groups (NSGs)**, and demonstrate subnet peering as a foundation for internal communication.

---

## 🎯 Objectives

- Create a VNet with multiple subnets
- Attach NSGs with custom rules
- Optionally peer two VNets for cross-subnet routing

---

## 🧰 Prerequisites

- Azure account with Network Contributor role
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB04-VNET/
├── main.tf               # Virtual network, subnets, and NSGs
├── variables.tf          # Address space, subnet names, security rules
├── outputs.tf            # VNet ID, subnet IDs, NSG names
├── terraform.tfvars      # Input values (optional)
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
```bash
terraform init
```

2. **Plan and apply configuration**
```bash
terraform plan
terraform apply
```

3. **Verify subnet layout and NSG rule application**

---

## 🧼 Cleanup

```bash
terraform destroy
```
This will delete the entire VNet and associated resources.

---

## 💡 Key Concepts

- **VNet**: Azure's logically isolated network space
- **Subnet**: Divides a VNet into IP ranges for deployments
- **NSG**: Stateful firewall for controlling traffic in/out of resources
- **VNet Peering**: Links two VNets for cross-communication

---

## 🧪 Optional Challenges

- Deploy two VNets and peer them
- Create subnet-specific NSG rules
- Add DNS servers to the VNet configuration

---

## 📚 References

- [Terraform VNet Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
- [Azure VNet Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)

---

## ✅ Summary

You've now created an Azure VNet and secured it with NSGs using Terraform. This lab forms the network foundation for deploying VMs, containers, or databases.

**Next up:** Load balance traffic to scalable VM sets in LAB05.