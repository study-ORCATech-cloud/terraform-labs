# TODO: Configure the AzureAD Provider
# Requirements:
# - Use the AzureAD provider (separate from AzureRM)
# - Ensure tenant_id is properly set

provider "azuread" {
  # TODO: Configure the tenant_id using var.tenant_id
}

# TODO: Create Azure AD Users
# Requirements:
# - Use azuread_user resource
# - Create users with details from var.users_list
# - Use for_each to iterate through the list
# - Set user_principal_name, display_name, mail, job_title, etc.
# - Set password with var.default_password

# TODO: Create Azure AD Groups
# Requirements:
# - Use azuread_group resource
# - Create groups with details from var.groups_list
# - Use for_each to iterate through the list
# - Set display_name, description, security_enabled, etc.

# TODO: Add Users to Groups
# Requirements:
# - Use azuread_group_member resource
# - Assign users to groups based on var.group_memberships
# - Use for_each to iterate through the group memberships
# - Reference user IDs and group IDs created above

# TODO: Create Role Assignments (Optional)
# Requirements:
# - Use azurerm_role_assignment resource
# - Assign Azure built-in roles to groups
# - Use scope to limit permissions to specific resources
# - Use for_each to iterate through var.role_assignments
# - Reference group IDs created above

# Note: For role assignments, you'll need both the AzureAD and AzureRM providers configured 
