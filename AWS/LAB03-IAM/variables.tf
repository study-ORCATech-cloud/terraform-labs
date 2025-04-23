variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name for tagging resources"
  type        = string
  default     = "dev"
}

variable "iam_user_names" {
  description = "List of IAM user names to create"
  type        = list(string)
  default     = ["terraform-admin", "terraform-developer", "terraform-readonly"]
}

variable "iam_user_path" {
  description = "The path for IAM users"
  type        = string
  default     = "/"
}

variable "create_access_keys" {
  description = "Whether to create access keys for IAM users"
  type        = bool
  default     = false # Set to false by default for security reasons
}

variable "iam_group_names" {
  description = "List of IAM group names to create"
  type        = list(string)
  default     = ["Administrators", "Developers", "ReadOnly"]
}

variable "iam_group_path" {
  description = "The path for IAM groups"
  type        = string
  default     = "/"
}

variable "user_group_memberships" {
  description = "List of user to group memberships"
  type = list(object({
    user  = string
    group = string
  }))
  default = [
    {
      user  = "terraform-admin"
      group = "Administrators"
    },
    {
      user  = "terraform-developer"
      group = "Developers"
    },
    {
      user  = "terraform-readonly"
      group = "ReadOnly"
    }
  ]
}

variable "custom_policy_attachments" {
  description = "List of groups to attach custom policies to"
  type        = list(string)
  default     = ["Developers", "ReadOnly"]
}

variable "create_custom_policy" {
  description = "Whether to create a custom policy from JSON file"
  type        = bool
  default     = true
}

variable "create_cross_account_role" {
  description = "Whether to create a cross-account role"
  type        = bool
  default     = false
}

variable "trusted_account_id" {
  description = "The AWS account ID that is trusted to assume the role (null means current account)"
  type        = string
  default     = null
} 
