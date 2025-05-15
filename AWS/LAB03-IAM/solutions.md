# LAB03: IAM (Identity and Access Management) - Solutions

This document contains solutions to the TODOs in the main.tf and outputs.tf files for LAB03.

## Solutions for main.tf

### Solution: Create IAM Users

```hcl
# Create IAM users
resource "aws_iam_user" "lab_users" {
  for_each = toset(var.iam_user_names)

  name          = each.value
  path          = var.iam_user_path
  force_destroy = true # Ensures user can be deleted even if it has non-Terraform-managed attachments

  tags = {
    Environment = var.environment
    Lab         = "LAB03-IAM"
    CreatedBy   = "Terraform"
  }
}
```

### Solution: Create Access Keys

```hcl
# Create access keys for users if enabled
resource "aws_iam_access_key" "user_access_keys" {
  for_each = var.create_access_keys ? toset(var.iam_user_names) : []

  user = aws_iam_user.lab_users[each.value].name
}
```

### Solution: Create IAM Groups

```hcl
# Create IAM groups
resource "aws_iam_group" "lab_groups" {
  for_each = toset(var.iam_group_names)

  name = each.value
  path = var.iam_group_path
}
```

### Solution: Add Users to Groups

```hcl
# Add users to groups
resource "aws_iam_user_group_membership" "user_group_membership" {
  for_each = {
    for pair in var.user_group_memberships : "${pair.user}.${pair.group}" => pair
  }

  user   = aws_iam_user.lab_users[each.value.user].name
  groups = [aws_iam_group.lab_groups[each.value.group].name]
}
```

### Solution: Create S3 Read-Only Policy

```hcl
# Create custom policy for S3 read-only access
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

### Solution: Create EC2 Read-Only Policy

```hcl
# Create custom policy for EC2 read-only access
resource "aws_iam_policy" "ec2_read_only" {
  name        = "CustomEC2ReadOnlyAccess"
  description = "Custom policy for EC2 read-only access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*"
        ]
        Resource = "*"
      }
    ]
  })
}
```

### Solution: Create Custom Policy from JSON File

```hcl
# Create a custom inline policy from JSON file
resource "aws_iam_policy" "custom_policy" {
  count = var.create_custom_policy ? 1 : 0

  name        = "CustomTerraformLabPolicy"
  description = "Custom policy created from JSON file"
  policy      = file("${path.module}/policies/custom-policy.json")
}
```

### Solution: Attach AWS Managed Policies to Groups

```hcl
# Attach AWS managed policies to groups
resource "aws_iam_group_policy_attachment" "admin_group_policy" {
  count = contains(var.iam_group_names, "Administrators") ? 1 : 0

  group      = aws_iam_group.lab_groups["Administrators"].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "developer_group_policy" {
  count = contains(var.iam_group_names, "Developers") ? 1 : 0

  group      = aws_iam_group.lab_groups["Developers"].name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_group_policy_attachment" "readonly_group_policy" {
  count = contains(var.iam_group_names, "ReadOnly") ? 1 : 0

  group      = aws_iam_group.lab_groups["ReadOnly"].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
```

### Solution: Attach S3 Read-Only Policy to Groups

```hcl
# Attach custom S3 read-only policy to groups
resource "aws_iam_group_policy_attachment" "s3_readonly_policy_attachment" {
  for_each = {
    for group in var.custom_policy_attachments :
    "${group}" => group
    if contains(var.iam_group_names, group) && contains(["Developers", "ReadOnly"], group)
  }

  group      = aws_iam_group.lab_groups[each.key].name
  policy_arn = aws_iam_policy.s3_read_only.arn
}
```

### Solution: Attach EC2 Read-Only Policy to Groups

```hcl
# Attach custom EC2 read-only policy to groups
resource "aws_iam_group_policy_attachment" "ec2_readonly_policy_attachment" {
  for_each = {
    for group in var.custom_policy_attachments :
    "${group}" => group
    if contains(var.iam_group_names, group) && contains(["Developers", "ReadOnly"], group)
  }

  group      = aws_iam_group.lab_groups[each.key].name
  policy_arn = aws_iam_policy.ec2_read_only.arn
}
```

### Solution: Create IAM Role for EC2

```hcl
# Create an IAM role for EC2 instances
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

### Solution: Attach Policy to EC2 Role

```hcl
# Attach S3 read-only policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_s3_readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}
```

### Solution: Create Instance Profile

```hcl
# Create an instance profile for the EC2 role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}
```

### Solution: Create Cross-Account Role

```hcl
# Create a role for cross-account access if enabled
resource "aws_iam_role" "cross_account_role" {
  count = var.create_cross_account_role ? 1 : 0

  name = "CrossAccountRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        # Uncomment `Principal` section if you provided `trusted_account_id`
        # Principal = {
        #   AWS = var.trusted_account_id != null ? "arn:aws:iam::${var.trusted_account_id}:root" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        # }
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

## Solutions for outputs.tf

### Solution: User ARNs Output

```hcl
output "user_arns" {
  description = "The ARNs of the created IAM users"
  value       = { for name, user in aws_iam_user.lab_users : name => user.arn }
}
```

### Solution: User Names Output

```hcl
output "user_names" {
  description = "The names of the created IAM users"
  value       = [for user in aws_iam_user.lab_users : user.name]
}
```

### Solution: Group ARNs Output

```hcl
output "group_arns" {
  description = "The ARNs of the created IAM groups"
  value       = { for name, group in aws_iam_group.lab_groups : name => group.arn }
}
```

### Solution: Group Names Output

```hcl
output "group_names" {
  description = "The names of the created IAM groups"
  value       = [for group in aws_iam_group.lab_groups : group.name]
}
```

### Solution: Custom Policy ARNs Output

```hcl
output "custom_policy_arns" {
  description = "ARNs of custom policies"
  value = {
    "S3ReadOnly"   = aws_iam_policy.s3_read_only.arn,
    "EC2ReadOnly"  = aws_iam_policy.ec2_read_only.arn,
    "CustomPolicy" = var.create_custom_policy ? aws_iam_policy.custom_policy[0].arn : null
  }
}
```

### Solution: EC2 Role ARN Output

```hcl
output "ec2_role_arn" {
  description = "The ARN of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}
```

### Solution: EC2 Instance Profile Name Output

```hcl
output "ec2_instance_profile_name" {
  description = "The name of the instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_profile.name
}
```

### Solution: EC2 Instance Profile ARN Output

```hcl
output "ec2_instance_profile_arn" {
  description = "The ARN of the instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_profile.arn
}
```

### Solution: Cross-Account Role ARN Output

```hcl
output "cross_account_role_arn" {
  description = "The ARN of the cross-account role (if created)"
  value       = var.create_cross_account_role ? aws_iam_role.cross_account_role[0].arn : null
}
```

### Solution: User Group Memberships Output

```hcl
output "user_group_memberships" {
  description = "The mapping of users to groups"
  value = {
    for key, membership in aws_iam_user_group_membership.user_group_membership :
    split(".", key)[0] => split(".", key)[1]
  }
}
```

### Solution: Access Key IDs Output

```hcl
output "access_key_ids" {
  description = "The access key IDs for the IAM users (if enabled)"
  value       = var.create_access_keys ? { for name, key in aws_iam_access_key.user_access_keys : name => key.id } : {}
  sensitive   = false # Access key IDs are not considered sensitive
}
```

### Solution: Access Key Secrets Output

```hcl
output "access_key_secrets" {
  description = "The access key secrets for the IAM users (if enabled)"
  value       = var.create_access_keys ? { for name, key in aws_iam_access_key.user_access_keys : name => key.secret } : {}
  sensitive   = true # Marking as sensitive to prevent display in console/logs
}
```

## Explanation

### IAM Users and Access Keys
- We create users in a loop using `for_each` with the list of user names.
- The `force_destroy` attribute allows Terraform to delete users even if they have attached resources not managed by Terraform.
- Access keys are created conditionally based on the `create_access_keys` variable.

### IAM Groups and Memberships
- Groups are created in a loop similar to users.
- User-group memberships use a more complex `for_each` that transforms the list of object variable into a map with unique keys based on the user-group pair.

### IAM Policies
- Two custom policies are created directly in the code using `jsonencode()` for the policy document.
- A third policy is loaded from an external JSON file using the `file()` function.
- The custom policy from file is conditionally created based on a variable.

### Policy Attachments
- AWS managed policies are attached to groups using `count` with the `contains()` function to conditionally create resources.
- Custom policies are attached to specific groups using complex `for_each` expressions with conditions.

### IAM Roles
- The EC2 role uses an assume role policy that allows the EC2 service to assume the role.
- The cross-account role is conditionally created and allows another AWS account to assume it with a condition on the principal's Environment tag.

### Instance Profile
- The instance profile is created and associated with the EC2 role to allow EC2 instances to assume the role.

### Outputs
- Various outputs use collection manipulation to return different views of the created resources.
- Some outputs are conditional based on whether certain resources were created.
- The access key secrets output is marked as sensitive to prevent accidental exposure.

## Testing
After implementing these solutions and running `terraform apply`, you should be able to:
1. Verify the IAM users, groups, and roles in the AWS console
2. Check policy attachments are correct for each group
3. Validate that the EC2 instance profile works by attaching it to an EC2 instance
4. Test cross-account access if that feature is enabled

## Security Considerations
- In production, you should never create access keys through Terraform as they would be stored in state files.
- The policies in this lab are quite permissive for learning purposes; in production, you should follow the principle of least privilege.
- Consider using AWS SSO for user management in production rather than IAM users.
- Cross-account roles should have strict conditions and MFA requirements in production. 
