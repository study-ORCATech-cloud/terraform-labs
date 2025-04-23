# LAB01: Provision an EC2 Instance with Terraform

## 📝 Lab Overview

In this lab, you’ll use **Terraform** to provision a basic **EC2 instance** on AWS. This introduces Infrastructure as Code (IaC) and helps you understand how Terraform can automate manual cloud provisioning.

---

## 🎯 Objectives

- Initialize a Terraform project
- Configure a provider for AWS
- Create an EC2 instance using Terraform
- Output key instance details (e.g., public IP)

---

## 🧰 Prerequisites

- AWS account with access key and secret
- Terraform v1.3+ installed
- AWS CLI configured (or environment variables set)

---

## 📁 File Structure

```bash
AWS/LAB01-EC2-Instance/
├── main.tf              # Terraform configuration for EC2
├── variables.tf         # Input variables for flexibility
├── outputs.tf           # Output EC2 instance details
├── terraform.tfvars     # Values for declared variables (optional)
└── README.md            # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Validate the configuration**
   ```bash
   terraform validate
   ```

3. **Preview the resources to be created**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```
   Confirm with `yes` when prompted.

5. **Retrieve public IP** (from output or AWS Console)

---

## 🧼 Cleanup

To avoid unnecessary charges:
```bash
terraform destroy
```
Confirm with `yes` when prompted.

---

## 💡 Key Concepts

- **Providers**: Enable Terraform to interact with AWS
- **Resources**: Describe what you want to create (e.g., `aws_instance`)
- **Variables**: Make your code reusable
- **Outputs**: Extract key details post-deployment

---

## 🧪 Optional Challenges

- Add a **security group** allowing SSH access
- Use a **user_data** script to install Apache or Nginx
- Output the instance’s DNS name

---

## 📚 References

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EC2 Documentation](https://docs.aws.amazon.com/ec2/)

---

## ✅ Summary

You’ve now deployed an EC2 instance using Terraform, a foundational IaC skill. This sets the stage for more complex labs involving networking, IAM, and multi-resource stacks.

**Next up:** Automate S3 bucket creation and management in LAB02.