# LAB03: Managing IAM Users, Groups, Roles, and Policies with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to manage **AWS Identity and Access Management (IAM)** resources. IAM is a web service that helps you securely control access to AWS resources. You'll learn how to create and manage IAM users, groups, policies, and roles programmatically, which is crucial for implementing a secure, least-privilege access model in AWS.

This lab demonstrates how infrastructure as code can simplify and standardize the management of permissions and access control in AWS environments.

---

## 🎯 Learning Objectives

- Create and manage IAM users with appropriate configuration
- Organize users into logical groups for permission management
- Create custom IAM policies using JSON encoding and policy files
- Attach AWS managed and custom policies to groups
- Create IAM roles with trust relationships for EC2 instances
- Configure instance profiles for EC2 service roles
- Implement cross-account access through roles (optional)
- Apply IAM security best practices in an infrastructure as code environment

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

### Step 4: Complete the TODO Sections

This lab contains several TODO sections that you need to complete:

1. In `main.tf`:
   - Create IAM users using a for_each loop
   - Create access keys for users (conditionally)
   - Create IAM groups using a for_each loop
   - Add users to groups using user_group_memberships variable
   - Create custom policies for S3 and EC2 read-only access
   - Create a custom policy from a JSON file (conditionally)
   - Attach AWS managed policies to appropriate groups
   - Attach custom policies to groups based on conditions
   - Create an IAM role for EC2 instances with trust policy
   - Create an instance profile for the EC2 role
   - Create a cross-account role (conditionally)

2. In `outputs.tf`:
   - Define outputs for IAM users, groups, policies, and roles
   - Define conditional outputs for access keys and cross-account role

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the IAM resources to be created:
   - IAM users with their configuration and tags
   - IAM groups for organizing users
   - User-group memberships for permission assignment
   - Custom IAM policies with specific permissions
   - Policy attachments to groups
   - IAM roles with trust relationships
   - Instance profile for EC2 service access
   - Cross-account role (if enabled)

### Step 6: Apply the Configuration

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
   - Access key IDs and secrets (if enabled)

### Step 7: Explore the IAM Resources

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

5. If you created access keys, securely store them or test them:
   ```bash
   # Use access keys to configure another AWS profile
   aws configure --profile terraform-user
   # Enter the access key ID and secret access key when prompted
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
    CreatedBy   = "Terraform"
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
          "s3:Describe*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*"
        ]
        Resource = "*"
      }
    ]
  })
}
```

Defines IAM policies using inline JSON or by referencing external JSON files. In this example, we create a custom policy for S3 read-only access.

### Policy Attachments

```hcl
resource "aws_iam_group_policy_attachment" "admin_policy" {
  count      = contains(var.iam_group_names, "Administrators") ? 1 : 0
  group      = "Administrators"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
```

Attaches policies to groups conditionally based on whether the group exists.

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
  
  tags = {
    Environment = var.environment
    Lab         = "LAB03-IAM"
    CreatedBy   = "Terraform"
  }
}
```

Creates a role that can be assumed by EC2 instances, enabling instances to make API requests to AWS services securely using temporary credentials rather than hardcoded access keys.

### Instance Profiles

```hcl
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}
```

Instance profiles are used to pass an IAM role to an EC2 instance. They serve as a container for an IAM role that can be used with EC2 instances.

### Cross-Account Roles

```hcl
resource "aws_iam_role" "cross_account_role" {
  count = var.create_cross_account_role ? 1 : 0
  name  = "CrossAccountRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_account_id != null ? var.trusted_account_id : data.aws_caller_identity.current.account_id
        }
        Condition = {
          StringEquals = {
            "aws:PrincipalTag/Environment" = var.environment
          }
        }
      }
    ]
  })
  
  tags = {
    Environment = var.environment
    Lab         = "LAB03-IAM"
    CreatedBy   = "Terraform"
  }
}
```

Creates a role that can be assumed by principals in another AWS account, which is useful for cross-account access management.

---

## 💡 Key Learning Points

1. **IAM Best Practices**: 
   - Use groups instead of attaching policies directly to users
   - Apply least privilege principle by creating custom policies
   - Avoid creating access keys when not needed
   - Use roles for service access instead of embedding credentials
   - Add conditions to limit when and where permissions are granted

2. **Terraform Techniques**:
   - Using `for_each` with sets and maps for multiple similar resources
   - Creating complex conditional expressions for resource creation
   - Using `jsonencode` function for inline policy documents
   - Loading external policy files with the `file` function
   - Using data sources to reference existing resources

3. **Security Principles**:
   - Separation of duties through different IAM groups
   - Least privilege access through custom policies
   - Temporary credentials through IAM roles
   - Fine-grained access control with conditions
   - Secure management of programmatic access

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
   Create a policy that denies access to sensitive actions unless MFA is present:
   ```hcl
   resource "aws_iam_policy" "require_mfa" {
     name        = "RequireMFA"
     description = "Policy that denies access to sensitive actions unless MFA is enabled"
     
     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Sid    = "DenyWithoutMFA"
           Effect = "Deny"
           Action = [
             "iam:*",
             "ec2:*",
             "rds:*"
           ]
           Resource = "*"
           Condition = {
             BoolIfExists = {
               "aws:MultiFactorAuthPresent" = "false"
             }
           }
         }
       ]
     })
   }
   ```

3. **Create a Permission Boundary**:
   Implement permission boundaries to limit the maximum permissions for users:
   ```hcl
   resource "aws_iam_policy" "developer_boundary" {
     name        = "DeveloperPermissionBoundary"
     description = "Permission boundary for developers"
     
     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect   = "Allow"
           Action   = [
             "s3:*",
             "ec2:Describe*",
             "cloudwatch:*",
             "logs:*"
           ]
           Resource = "*"
         },
         {
           Effect   = "Deny"
           Action   = [
             "iam:*",
             "organizations:*"
           ]
           Resource = "*"
         }
       ]
     })
   }
   
   resource "aws_iam_user_policy_attachment" "boundary_attachment" {
     for_each = {
       for user in var.iam_user_names : user => user
       if contains(["terraform-developer1", "terraform-developer2"], user)
     }
     
     user       = aws_iam_user.lab_users[each.key].name
     policy_arn = aws_iam_policy.developer_boundary.arn
   }
   ```

4. **Implement Access Analyzer**:
   Create an IAM Access Analyzer to identify resources shared with external entities:
   ```hcl
   resource "aws_accessanalyzer_analyzer" "organization_analyzer" {
     analyzer_name = "organization-analyzer"
     type          = "ORGANIZATION"
   }
   ```

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

4. **InvalidInput for policy attachments**:
   ```
   Error: InvalidInput: No such group: Developers
   ```
   **Solution**: Ensure the group is created before attempting to attach policies to it.

5. **MalformedPolicyDocument for roles**:
   ```
   Error: MalformedPolicyDocument: The policy document must have a Version element
   ```
   **Solution**: Ensure your policy JSON includes `"Version": "2012-10-17"` and properly formatted statements.

---

## 📚 Additional Resources

- [Terraform AWS IAM Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [IAM Policy Simulator](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_testing-policies.html)
- [IAM Access Analyzer](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)
- [AWS Security Blog - IAM](https://aws.amazon.com/blogs/security/category/identity-access-management/)

---

## 🚀 Next Lab

Proceed to [LAB04-VPC](../LAB04-VPC/) to learn how to create and configure Virtual Private Clouds (VPCs) in AWS using Terraform.

---

Happy Terraforming!