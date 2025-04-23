# LAB03: Managing IAM Users, Groups, Roles, and Policies with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to manage **AWS Identity and Access Management (IAM)** resources. IAM is a web service that helps you securely control access to AWS resources. You'll learn how to create and manage IAM users, groups, policies, and roles programmatically, which is crucial for implementing a secure, least-privilege access model in AWS.

This lab demonstrates how infrastructure as code can simplify and standardize the management of permissions and access control in AWS environments.

---

## 🎯 Learning Objectives

- Create and manage IAM users using Terraform
- Organize users into groups with appropriate permissions
- Create and attach custom policies to control access
- Configure service roles for EC2 instances
- Implement cross-account access (optional)
- Understand IAM best practices and security considerations
- Apply proper cleanup procedures to remove IAM resources

---

## 🧰 Prerequisites

- AWS account with administrator access
- Terraform v1.3+ installed
- AWS CLI installed and configured with credentials
- Basic understanding of IAM concepts (users, groups, policies, roles)

---

## 📁 Files Structure

```
AWS/LAB03-IAM/
├── main.tf                  # Main configuration with IAM resources
├── variables.tf             # Variable declarations
├── outputs.tf               # Output definitions
├── policies/                # Directory for custom policy JSON files
│   └── custom-policy.json   # Example custom policy
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
└── README.md                # Lab instructions
```

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB03-IAM
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure IAM Resources

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Customize the configuration in `terraform.tfvars` to adjust user names, group memberships, etc.

   > ⚠️ **Important**: For security best practices, set `create_access_keys` to `false` unless you specifically need to create programmatic access keys.

### Step 4: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the IAM resources to be created:
   - IAM users (terraform-admin, terraform-developer, terraform-readonly)
   - IAM groups (Administrators, Developers, ReadOnly)
   - Group memberships and policy attachments
   - Custom policies and IAM roles
   - Instance profile for EC2

### Step 5: Create the IAM Resources

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, Terraform will display outputs including:
   - User ARNs and names
   - Group ARNs and names
   - Policy ARNs
   - Role ARNs
   - Access key IDs (if enabled)

### Step 6: Explore the IAM Resources

1. Verify the created users in the AWS Console or CLI:
   ```bash
   aws iam list-users
   ```

2. List the groups and their memberships:
   ```bash
   aws iam list-groups
   
   # For a specific group
   aws iam get-group --group-name Developers
   ```

3. Check attached policies:
   ```bash
   aws iam list-attached-group-policies --group-name Developers
   ```

4. Examine the EC2 role and its trust policy:
   ```bash
   aws iam get-role --role-name EC2InstanceRole
   ```

---

## 🔍 Understanding the Code

### IAM Users

```hcl
resource "aws_iam_user" "lab_users" {
  for_each = toset(var.iam_user_names)
  
  name          = each.value
  path          = var.iam_user_path
  force_destroy = true
  
  tags = {
    Environment = var.environment
    Lab         = "LAB03-IAM"
  }
}
```

This resource creates IAM users using Terraform's `for_each` to iterate through a list of user names. The `force_destroy` attribute ensures users can be deleted even when they have non-Terraform-managed attachments.

### IAM Groups

```hcl
resource "aws_iam_group" "lab_groups" {
  for_each = toset(var.iam_group_names)
  
  name = each.value
  path = var.iam_group_path
}
```

Creates groups to organize users. Groups make it easier to manage permissions as you can attach policies to groups instead of individual users.

### Group Memberships

```hcl
resource "aws_iam_user_group_membership" "user_group_membership" {
  for_each = {
    for pair in var.user_group_memberships : "${pair.user}.${pair.group}" => pair
  }
  
  user   = aws_iam_user.lab_users[each.value.user].name
  groups = [aws_iam_group.lab_groups[each.value.group].name]
}
```

Associates users with their respective groups using a complex `for_each` construct that creates a map from a list of objects.

### Custom Policies

```hcl
resource "aws_iam_policy" "s3_read_only" {
  name        = "CustomS3ReadOnlyAccess"
  description = "Custom policy for S3 read-only access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}
```

Defines IAM policies using inline JSON or by referencing external JSON files. In this example, we create a custom policy for S3 read-only access.

### Service Roles

```hcl
resource "aws_iam_role" "ec2_role" {
  name = "EC2InstanceRole"
  path = "/service-role/"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
```

Creates a role that can be assumed by EC2 instances, enabling instances to make API requests to AWS services securely.

---

## 💡 Key Learning Points

1. **IAM Best Practices**: 
   - Use groups instead of attaching policies directly to users
   - Apply least privilege principle by creating custom policies
   - Avoid creating access keys when not needed
   - Use roles for service access instead of embedding credentials

2. **Terraform Techniques**:
   - Using `for_each` with sets and maps
   - Conditional resource creation
   - External policy files
   - Managing resource dependencies

3. **Security Principles**:
   - Separation of duties through different IAM groups
   - Least privilege access through custom policies
   - Temporary credentials through IAM roles

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Create a Password Policy**:
   ```hcl
   resource "aws_iam_account_password_policy" "strict" {
     minimum_password_length        = 12
     require_uppercase_characters   = true
     require_lowercase_characters   = true
     require_numbers                = true
     require_symbols                = true
     allow_users_to_change_password = true
     password_reuse_prevention      = 24
     max_password_age               = 90
   }
   ```

2. **Implement MFA Enforcement**:
   Create a policy that denies access to sensitive actions unless MFA is present.

3. **Create a Boundary Policy**:
   Implement permission boundaries to limit the maximum permissions for users.

---

## 🧼 Cleanup

To avoid potential security risks and keep your AWS account clean:

1. First, check for any created resources:
   ```bash
   terraform state list
   ```

2. Destroy all resources created by Terraform:
   ```bash
   terraform destroy
   ```

3. Type `yes` when prompted

4. Verify in the AWS Console that the resources have been removed:
   - Navigate to IAM in the AWS Console
   - Confirm that the created users, groups, and roles no longer exist

5. For thorough cleanup, also check for any resources that might not have been managed by Terraform:
   ```bash
   # Check for remaining users
   aws iam list-users --query "Users[?contains(UserName, 'terraform')]"
   
   # Check for remaining groups
   aws iam list-groups
   
   # Check for remaining roles
   aws iam list-roles --query "Roles[?contains(RoleName, 'EC2Instance') || contains(RoleName, 'CrossAccount')]"
   ```

6. If any resources remain, delete them manually:
   ```bash
   # Delete a user
   aws iam delete-user --user-name USER_NAME
   
   # Delete a group
   aws iam delete-group --group-name GROUP_NAME
   
   # Delete a role
   aws iam delete-role --role-name ROLE_NAME
   ```

7. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars
   ```

> ⚠️ **Important**: IAM resources don't incur charges, but it's still important to clean them up for security reasons and to maintain a clean AWS account.

---

## 🚫 Common Errors and Troubleshooting

1. **EntityAlreadyExists**:
   ```
   Error: EntityAlreadyExists: User with name terraform-admin already exists.
   ```
   **Solution**: Choose different user names or delete existing users.

2. **DeleteConflict when destroying**:
   ```
   Error: DeleteConflict: Cannot delete entity, must remove all access keys first
   ```
   **Solution**: Set `force_destroy = true` on IAM users or delete access keys manually.

3. **NoSuchEntity during cleanup**:
   ```
   Error: NoSuchEntity: The user with name terraform-admin cannot be found.
   ```
   **Solution**: The resource may have already been deleted; you can ignore this error or use `-refresh=false` with `terraform destroy`.

---

## 📚 Additional Resources

- [Terraform AWS IAM Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Simulator](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html)
- [IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

---

## 🚀 Next Lab

Proceed to [LAB04-VPC](../LAB04-VPC/) to learn how to create and configure Virtual Private Clouds (VPCs) in AWS using Terraform.

---

Happy Terraforming!