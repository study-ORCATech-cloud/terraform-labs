# LAB05: Deploy a Load Balancer and Auto Scaling Group with Terraform

## 📝 Lab Overview

In this lab, you'll build a scalable infrastructure by provisioning an **Application Load Balancer (ALB)** and an **Auto Scaling Group (ASG)** using **Terraform**. You’ll define a launch template and connect instances to a target group for high availability.

---

## 🎯 Objectives

- Create a launch template for EC2 instances
- Define an Auto Scaling Group with scaling policies
- Attach the group to an Application Load Balancer

---

## 🧰 Prerequisites

- Terraform v1.3+ installed
- Existing VPC with subnets (from LAB04 or imported)

---

## 📁 File Structure

```bash
AWS/LAB05-ELB-ASG/
├── main.tf               # ALB, ASG, and dependencies
├── variables.tf          # Subnet IDs, AMI ID, etc.
├── outputs.tf            # Load balancer DNS, instance IDs
├── terraform.tfvars      # Pre-defined inputs (optional)
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Set environment variables or edit `terraform.tfvars`**
2. **Initialize Terraform**
   ```bash
   terraform init
   ```
3. **Preview and apply configuration**
   ```bash
   terraform plan
   terraform apply
   ```
4. **Visit ALB DNS name** to access deployed instances

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure instances are terminated and ELB is deleted

---

## 💡 Key Concepts

- **Launch Template**: Reusable EC2 config for scaling
- **ASG**: Scales instance count based on target policy
- **ALB**: Distributes traffic across healthy EC2 instances
- **Target Group**: Tracks EC2 health via defined port

---

## 🧪 Optional Challenges

- Enable HTTPS listener with self-signed cert
- Scale in/out based on CPU usage (CloudWatch alarms)
- Customize instance user data to serve a web app

---

## 📚 References

- [Terraform ASG Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
- [AWS ELB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/)

---

## ✅ Summary

You've deployed a highly available, automatically scaling application infrastructure using Terraform. This is a cornerstone pattern in production-grade cloud architecture.

**Next up:** Monitor and alert on system metrics using CloudWatch in LAB06.