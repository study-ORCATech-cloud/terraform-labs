# LAB03: Manage IAM Users, Roles, and Policies with Terraform

## 📝 Lab Overview

In this lab, you’ll use **Terraform** to manage **AWS IAM**. You’ll create IAM users, groups, policies, and roles. This is foundational for securing and managing access across cloud infrastructure.

---

## 🎯 Objectives

- Create IAM users and groups using Terraform
- Attach managed or custom IAM policies
- Define and assign IAM roles for services

---

## 🧰 Prerequisites

- AWS account with IAM permissions
- Terraform v1.3+ installed

---

## 📁 File Structure

```bash
AWS/LAB03-IAM/
├── main.tf              # IAM resources and policies
├── variables.tf         # User, group, and policy variables
├── outputs.tf           # Outputs like user name or role ARN
├── policies/            # Folder for custom JSON policy files
│   └── custom-policy.json
├── terraform.tfvars     # Optional variable values
└── README.md            # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize project**
   ```bash
   terraform init
   ```

2. **Plan and apply configuration**
   ```bash
   terraform plan
   terraform apply
   ```

3. **Verify IAM resources in the AWS Console or via CLI**

---

## 🧼 Cleanup

```bash
terraform destroy
```
To delete all created IAM users, groups, roles, and policies.

---

## 💡 Key Concepts

- **aws_iam_user / group / policy / role**: Core identity and access resources
- **Policy attachment**: Use both `aws_iam_policy_attachment` and inline policies
- **IAM Role**: Often used for EC2, Lambda, or cross-account permissions

---

## 🧪 Optional Challenges

- Create a custom policy using a JSON file
- Allow only S3 read-only access
- Create a role assumed by EC2

---

## 📚 References

- [Terraform IAM Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)
- [AWS IAM Documentation](https://docs.aws.amazon.com/IAM/)

---

## ✅ Summary

You’ve now defined IAM users, groups, and roles using Terraform. This is critical for creating secure and scalable cloud environments.

**Next up:** Build secure VPCs and isolate resources in LAB04.