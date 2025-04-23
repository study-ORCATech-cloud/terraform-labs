# LAB04: Build a Custom VPC with Subnets and Security Groups using Terraform

## 📝 Lab Overview

This lab introduces **network design and security** in AWS by building a custom **Virtual Private Cloud (VPC)** with public and private subnets. You’ll also create **Security Groups** for controlling inbound/outbound access.

---

## 🎯 Objectives

- Create a custom VPC and subnets
- Set up route tables, internet gateway, and NAT gateway
- Define security groups for web and internal access

---

## 🧰 Prerequisites

- AWS account with VPC permissions
- Terraform v1.3+ installed

---

## 📁 File Structure

```bash
AWS/LAB04-VPC/
├── main.tf               # All networking resources
├── variables.tf          # Input variables for CIDRs and tags
├── outputs.tf            # Key outputs: VPC ID, Subnet IDs
├── terraform.tfvars      # Optional override file
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Preview resources**
   ```bash
   terraform plan
   ```

3. **Apply configuration**
   ```bash
   terraform apply
   ```

4. **Verify VPC in AWS Console**

---

## 🧼 Cleanup

```bash
terraform destroy
```
This will remove all VPC components (Internet Gateway, subnets, route tables, etc.)

---

## 💡 Key Concepts

- **VPC**: Isolated network for AWS workloads
- **Subnets**: Public (for EC2), Private (for databases or internal apps)
- **Route Tables**: Control outbound routing
- **Security Groups**: Stateful firewalls for EC2 instances

---

## 🧪 Optional Challenges

- Add NACLs to enforce stateless subnet rules
- Add S3 VPC endpoint to access S3 without NAT Gateway
- Add tags to resources for better management

---

## 📚 References

- [Terraform VPC Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [AWS VPC Guide](https://docs.aws.amazon.com/vpc/latest/userguide/)

---

## ✅ Summary

You’ve now created a secure, scalable network architecture using Terraform. Mastering VPCs is essential before deploying applications in cloud environments.

**Next up:** Add load balancing and auto scaling to your applications in LAB05.