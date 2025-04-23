output "user_arns" {
  description = "The ARNs of the created IAM users"
  value       = { for name, user in aws_iam_user.lab_users : name => user.arn }
}

output "user_names" {
  description = "The names of the created IAM users"
  value       = [for user in aws_iam_user.lab_users : user.name]
}

output "group_arns" {
  description = "The ARNs of the created IAM groups"
  value       = { for name, group in aws_iam_group.lab_groups : name => group.arn }
}

output "group_names" {
  description = "The names of the created IAM groups"
  value       = [for group in aws_iam_group.lab_groups : group.name]
}

output "custom_policy_arns" {
  description = "ARNs of custom policies"
  value = {
    "S3ReadOnly"   = aws_iam_policy.s3_read_only.arn,
    "EC2ReadOnly"  = aws_iam_policy.ec2_read_only.arn,
    "CustomPolicy" = var.create_custom_policy ? aws_iam_policy.custom_policy[0].arn : null
  }
}

output "ec2_role_arn" {
  description = "The ARN of the IAM role for EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "The name of the instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_instance_profile_arn" {
  description = "The ARN of the instance profile for EC2 instances"
  value       = aws_iam_instance_profile.ec2_profile.arn
}

output "cross_account_role_arn" {
  description = "The ARN of the cross-account role (if created)"
  value       = var.create_cross_account_role ? aws_iam_role.cross_account_role[0].arn : null
}

output "user_group_memberships" {
  description = "The mapping of users to groups"
  value = {
    for key, membership in aws_iam_user_group_membership.user_group_membership :
    split(".", key)[0] => split(".", key)[1]
  }
}

output "access_key_ids" {
  description = "The access key IDs for the IAM users (if enabled)"
  value       = var.create_access_keys ? { for name, key in aws_iam_access_key.user_access_keys : name => key.id } : {}
  sensitive   = false # Access key IDs are not considered sensitive
}

output "access_key_secrets" {
  description = "The access key secrets for the IAM users (if enabled)"
  value       = var.create_access_keys ? { for name, key in aws_iam_access_key.user_access_keys : name => key.secret } : {}
  sensitive   = true # Marking as sensitive to prevent display in console/logs
} 
