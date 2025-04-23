# LAB04: Configure VPC Networks and Firewall Rules in GCP with Terraform

## 📝 Lab Overview

In this lab, you'll provision a custom **Virtual Private Cloud (VPC)** and define **firewall rules** using **Terraform**. These resources are foundational for network security and resource isolation in GCP.

---

## 🎯 Objectives

- Create a custom VPC and subnet
- Set up firewall rules for ingress and egress
- Enable external access only to approved services (e.g., SSH, HTTP)

---

## 🧰 Prerequisites

- GCP project with networking permissions
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB04-VPC-Firewall/
├── main.tf               # VPC and firewall resources
├── variables.tf          # CIDR blocks, ports, tags
├── outputs.tf            # Network and rule names
├── terraform.tfvars      # Optional overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and plan Terraform**
```bash
terraform init
terraform plan
```

2. **Apply configuration**
```bash
terraform apply
```

3. **Inspect VPC and rules via Console or CLI**

---

## 🧼 Cleanup

```bash
terraform destroy
```
Destroys the network and firewall settings

---

## 💡 Key Concepts

- **VPC**: Logical network isolated per project
- **Subnet**: Defines IP range and zone for attached resources
- **Firewall Rule**: Controls traffic based on IP, protocol, and port
- **Tags**: Allow rule targeting by instance metadata

---

## 🧪 Optional Challenges

- Add internal firewall rules for DB connectivity
- Restrict SSH to your own IP
- Peer two VPCs across projects or regions

---

## 📚 References

- [Terraform VPC Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)
- [GCP VPC Guide](https://cloud.google.com/vpc/docs/)

---

## ✅ Summary

You've configured a custom VPC and firewall rules using Terraform. This skill is essential for deploying secure, network-aware cloud applications.

**Next up:** Set up load balancing and managed instance groups in LAB05.

