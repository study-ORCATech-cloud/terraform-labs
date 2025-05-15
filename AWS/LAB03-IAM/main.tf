# --------------------------------
# IAM Users
# --------------------------------

# TODO: Create IAM users using a for_each loop
# Requirements:
# - Use the iam_user_names variable (list of strings) with toset() to create users 
# - Set name, path, and force_destroy attributes
# - Add tags for Environment, Lab="LAB03-IAM", and CreatedBy="Terraform"
# HINT: Use the aws_iam_user resource with for_each = toset(var.iam_user_names)

# TODO: Create access keys for users if enabled
# Requirements:
# - Only create access keys if var.create_access_keys is true
# - Use for_each to create keys for each user in iam_user_names
# - Reference the user name from the aws_iam_user resource created above
# HINT: Use for_each = var.create_access_keys ? toset(var.iam_user_names) : []

# --------------------------------
# IAM Groups
# --------------------------------

# TODO: Create IAM groups using a for_each loop
# Requirements:
# - Use the iam_group_names variable with toset() to create groups
# - Set name and path attributes
# HINT: Use the aws_iam_group resource

# TODO: Add users to groups
# Requirements:
# - Use the user_group_memberships variable to assign users to groups
# - Create a map from the list using a for_pair expression with a unique key
# - Set user and groups attributes, referencing resources created above
# HINT: for_each = { for pair in var.user_group_memberships : "${pair.user}.${pair.group}" => pair }

# --------------------------------
# IAM Policies
# --------------------------------

# TODO: Create custom policy for S3 read-only access
# Requirements:
# - Name it "CustomS3ReadOnlyAccess"
# - Include a description
# - Use jsonencode to create a policy that allows:
#   * s3:Get*, s3:List*, s3:Describe*
#   * s3-object-lambda:Get*, s3-object-lambda:List* 
# - Apply to all resources ("*")
# HINT: Use the aws_iam_policy resource with jsonencode for the policy document

# TODO: Create custom policy for EC2 read-only access
# Requirements:
# - Name it "CustomEC2ReadOnlyAccess"
# - Include a description
# - Use jsonencode to create a policy that allows:
#   * ec2:Describe*, ec2:Get*, ec2:List*
# - Apply to all resources ("*")
# HINT: Similar to the S3 policy above

# TODO: Create a custom inline policy from JSON file
# Requirements:
# - Only create if var.create_custom_policy is true
# - Name it "CustomTerraformLabPolicy"
# - Include a description
# - Load the policy from the file at policies/custom-policy.json
# HINT: Use count = var.create_custom_policy ? 1 : 0 and file() function

# --------------------------------
# Policy Attachments
# --------------------------------

# TODO: Attach AWS managed policies to groups
# Requirements:
# - Attach AdministratorAccess to the Administrators group (if it exists)
# - Attach PowerUserAccess to the Developers group (if it exists)
# - Attach ReadOnlyAccess to the ReadOnly group (if it exists)
# HINT: Use count with contains() function to check if the group exists

# TODO: Attach custom S3 read-only policy to Developer and ReadOnly groups
# Requirements:
# - Use for_each with a conditional expression
# - Only attach to groups in the custom_policy_attachments list
# - Only attach if the group exists in iam_group_names
# - Only attach to Developer or ReadOnly groups
# HINT: for_each with a complex condition that checks multiple contains()

# TODO: Attach custom EC2 read-only policy to Developer and ReadOnly groups
# Requirements:
# - Same conditions as the S3 policy attachment above
# - Reference the EC2 read-only policy
# HINT: Similar to the S3 policy attachment

# --------------------------------
# IAM Roles
# --------------------------------

# TODO: Create an IAM role for EC2 instances
# Requirements:
# - Name it "EC2InstanceRole"
# - Set the path to "/service-role/"
# - Create an assume_role_policy that allows ec2.amazonaws.com to assume the role
# - Add tags for Environment, Lab, and CreatedBy
# HINT: Use jsonencode for the assume_role_policy

# TODO: Attach S3 read-only policy to EC2 role
# Requirements:
# - Attach the S3 read-only policy created above to the EC2 role
# HINT: Use aws_iam_role_policy_attachment resource

# TODO: Create an instance profile for the EC2 role
# Requirements:
# - Name it "EC2InstanceProfile"
# - Associate it with the EC2 role created above
# HINT: Use aws_iam_instance_profile resource

# --------------------------------
# Optional: Cross-Account Role
# --------------------------------

# TODO: Create a role for cross-account access if enabled
# Requirements:
# - Only create if var.create_cross_account_role is true
# - Name it "CrossAccountRole"
# - Create an assume_role_policy that:
#   * Allows sts:AssumeRole action
#   * Specifies the AWS account from trusted_account_id (or current account if null)
#   * Includes a condition that requires Environment tag to match var.environment
# - Add appropriate tags
# HINT: Use count and jsonencode for the policy, reference data source for current account

# Get the current account ID
data "aws_caller_identity" "current" {}
