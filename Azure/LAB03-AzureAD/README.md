# LAB03: Manage Azure Active Directory Users, Groups, and Roles with Terraform

## 📝 Lab Overview

In this lab, you’ll provision **Azure Active Directory (Azure AD)** resources using **Terraform**. This includes creating users, groups, assigning roles, and implementing role-based access control (RBAC).

---

## 🎯 Objectives

- Create Azure AD users and groups
- Assign users to groups and roles
- Manage identities via Terraform

---

## 🧰 Prerequisites

- Azure AD tenant and Global Admin privileges
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB03-AzureAD/
├── main.tf               # User, group, role assignments
├── variables.tf          # Usernames, group names, etc.
├── outputs.tf            # User IDs, role IDs
├── terraform.tfvars      # Custom input values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Ensure you have admin access to Azure AD**
2. **Initialize Terraform**
```bash
terraform init
```
3. **Run Terraform plan and apply**
```bash
terraform plan
terraform apply
```
4. **Verify users and groups** in Azure AD via Portal or CLI

---

## 🧼 Cleanup

```bash
terraform destroy
```
Ensure no critical users or groups are deleted in production environments.

---

## 💡 Key Concepts

- **AzureAD Provider**: Separate from AzureRM, used for identity management
- **Users**: Identities in the tenant
- **Groups**: Used to manage permissions and role assignments
- **RBAC**: Assigns scopes and roles for access control

---

## 🧪 Optional Challenges

- Assign a built-in role (e.g., Contributor) to a group
- Create multiple users using `count`
- Integrate user creation with automated login credentials (use with caution)

---

## 📚 References

- [Terraform AzureAD Provider](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs)
- [Azure AD Overview](https://learn.microsoft.com/en-us/azure/active-directory/)

---

## ✅ Summary

You've now used Terraform to manage Azure AD users and roles, a foundational step in building secure, scalable identity infrastructure in Azure.

**Next up:** Build your first Azure Virtual Network and NSG in LAB04.