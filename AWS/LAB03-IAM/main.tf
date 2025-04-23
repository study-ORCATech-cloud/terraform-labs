provider "aws" {
  region = var.aws_region
}

# --------------------------------
# IAM Users
# --------------------------------

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

# Create access keys for users if enabled
resource "aws_iam_access_key" "user_access_keys" {
  for_each = var.create_access_keys ? toset(var.iam_user_names) : []

  user = aws_iam_user.lab_users[each.value].name
}

# --------------------------------
# IAM Groups
# --------------------------------

# Create IAM groups
resource "aws_iam_group" "lab_groups" {
  for_each = toset(var.iam_group_names)

  name = each.value
  path = var.iam_group_path
}

# Add users to groups
resource "aws_iam_user_group_membership" "user_group_membership" {
  for_each = {
    for pair in var.user_group_memberships : "${pair.user}.${pair.group}" => pair
  }

  user   = aws_iam_user.lab_users[each.value.user].name
  groups = [aws_iam_group.lab_groups[each.value.group].name]
}

# --------------------------------
# IAM Policies
# --------------------------------

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

# Create a custom inline policy from JSON file
resource "aws_iam_policy" "custom_policy" {
  count = var.create_custom_policy ? 1 : 0

  name        = "CustomTerraformLabPolicy"
  description = "Custom policy created from JSON file"
  policy      = file("${path.module}/policies/custom-policy.json")
}

# --------------------------------
# Policy Attachments
# --------------------------------

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

# Attach custom policies to groups
resource "aws_iam_group_policy_attachment" "s3_readonly_policy_attachment" {
  for_each = {
    for group in var.custom_policy_attachments :
    "${group}" => group
    if contains(var.iam_group_names, group) && contains(["Developers", "ReadOnly"], group)
  }

  group      = aws_iam_group.lab_groups[each.key].name
  policy_arn = aws_iam_policy.s3_read_only.arn
}

resource "aws_iam_group_policy_attachment" "ec2_readonly_policy_attachment" {
  for_each = {
    for group in var.custom_policy_attachments :
    "${group}" => group
    if contains(var.iam_group_names, group) && contains(["Developers", "ReadOnly"], group)
  }

  group      = aws_iam_group.lab_groups[each.key].name
  policy_arn = aws_iam_policy.ec2_read_only.arn
}

# --------------------------------
# IAM Roles
# --------------------------------

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

# Attach S3 read-only policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_s3_readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}

# Create an instance profile for the EC2 role
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# --------------------------------
# Optional: Cross-Account Role
# --------------------------------

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
        Principal = {
          AWS = var.trusted_account_id != null ? "arn:aws:iam::${var.trusted_account_id}:root" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
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

# Get the current account ID
data "aws_caller_identity" "current" {}
