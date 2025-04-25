# TODO: Define an output for user_arns
# Requirements:
# - Name it "user_arns"
# - Description should explain it returns the ARNs of created IAM users
# - Value should be a map of user names to their ARNs
# HINT: Use { for name, user in aws_iam_user.lab_users : name => user.arn }

# TODO: Define an output for user_names
# Requirements:
# - Name it "user_names"
# - Description should explain it returns the names of created IAM users
# - Value should be a list of user names
# HINT: Use [for user in aws_iam_user.lab_users : user.name]

# TODO: Define an output for group_arns
# Requirements:
# - Name it "group_arns"
# - Description should explain it returns the ARNs of created IAM groups
# - Value should be a map of group names to their ARNs
# HINT: Use { for name, group in aws_iam_group.lab_groups : name => group.arn }

# TODO: Define an output for group_names
# Requirements:
# - Name it "group_names"
# - Description should explain it returns the names of created IAM groups
# - Value should be a list of group names
# HINT: Use [for group in aws_iam_group.lab_groups : group.name]

# TODO: Define an output for custom_policy_arns
# Requirements:
# - Name it "custom_policy_arns"
# - Description should explain it returns ARNs of custom policies
# - Value should be a map with keys for each policy and their ARNs as values
# - Include conditional output for the custom_policy (with null if not created)
# HINT: Use a map with S3ReadOnly, EC2ReadOnly, and CustomPolicy keys

# TODO: Define an output for ec2_role_arn
# Requirements:
# - Name it "ec2_role_arn"
# - Description should explain it returns the ARN of the IAM role for EC2 instances
# - Value should be the ARN of the EC2 role
# HINT: Use aws_iam_role.ec2_role.arn

# TODO: Define an output for ec2_instance_profile_name
# Requirements:
# - Name it "ec2_instance_profile_name"
# - Description should explain it returns the name of the instance profile
# - Value should be the name of the EC2 instance profile
# HINT: Use aws_iam_instance_profile.ec2_profile.name

# TODO: Define an output for ec2_instance_profile_arn
# Requirements:
# - Name it "ec2_instance_profile_arn"
# - Description should explain it returns the ARN of the instance profile
# - Value should be the ARN of the EC2 instance profile
# HINT: Use aws_iam_instance_profile.ec2_profile.arn

# TODO: Define a conditional output for cross_account_role_arn
# Requirements:
# - Name it "cross_account_role_arn"
# - Description should explain it returns the ARN of the cross-account role (if created)
# - Value should be the ARN if created, otherwise null
# HINT: Use var.create_cross_account_role ? aws_iam_role.cross_account_role[0].arn : null

# TODO: Define an output for user_group_memberships
# Requirements:
# - Name it "user_group_memberships"
# - Description should explain it returns the mapping of users to groups
# - Value should transform the membership key into a user-to-group mapping
# HINT: Use a for expression with split(".") to extract user and group from the key

# TODO: Define an output for access_key_ids
# Requirements:
# - Name it "access_key_ids"
# - Description should explain it returns the access key IDs (if enabled)
# - Value should be a map of user names to their access key IDs
# - Sensitivity should be set to false (IDs are not sensitive)
# HINT: Use var.create_access_keys ? {...} : {}

# TODO: Define an output for access_key_secrets
# Requirements:
# - Name it "access_key_secrets"
# - Description should explain it returns the access key secrets (if enabled)
# - Value should be a map of user names to their access key secrets
# - Sensitivity should be set to true (secrets are sensitive!)
# HINT: Use var.create_access_keys ? {...} : {}
