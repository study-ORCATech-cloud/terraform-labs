# LAB05: Deploy Load Balancer with VM Scale Set using Terraform

## 📝 Lab Overview

In this lab, you'll deploy a **Load Balancer** connected to an **Azure Virtual Machine Scale Set (VMSS)** using **Terraform**. This allows you to serve web traffic through a pool of auto-scaling VMs.

---

## 🎯 Objectives

- Create a Load Balancer with frontend and backend configurations
- Provision a VM Scale Set using a launch template and autoscaling rules
- Configure NAT rules and health probes

---

## 🧰 Prerequisites

- Azure account with access to Compute and Networking
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB05-LoadBalancer-ScaleSet/
├── main.tf               # VMSS, LB, probe, and rules
├── variables.tf          # Image ID, port, scaling policies
├── outputs.tf            # Load balancer public IP, scale set info
├── terraform.tfvars      # Optional input overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and configure Terraform**
```bash
terraform init
terraform plan
terraform apply
```

2. **Access the public IP** of the load balancer and observe traffic

---

## 🧼 Cleanup

```bash
terraform destroy
```
Removes scale set instances and load balancer configuration

---

## 💡 Key Concepts

- **VM Scale Set**: Auto-managed compute pool
- **Load Balancer**: Routes traffic to healthy VMs
- **Health Probe**: Detects and isolates failed instances
- **Inbound NAT Rules**: Allow admin access to individual VM instances

---

## 🧪 Optional Challenges

- Add autoscaling based on CPU or custom metric
- Use custom startup script via `custom_data`
- Replace LB with Application Gateway for HTTP routing

---

## 📚 References

- [Terraform VMSS Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set)
- [Azure Load Balancer](https://learn.microsoft.com/en-us/azure/load-balancer/)

---

## ✅ Summary

You’ve now deployed a highly available infrastructure setup using VMSS and Azure Load Balancer. This is essential for horizontally scalable applications.

**Next up:** Add monitoring and log analytics to your Azure environment in LAB06.