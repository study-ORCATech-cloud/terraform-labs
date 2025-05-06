# LAB03: Azure Active Directory Solution

This document provides solutions for the Azure AD lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
# Configure the AzureAD Provider
provider "azuread" {
  tenant_id = var.tenant_id
}

# Configure the AzureRM Provider (for role assignments)
provider "azurerm" {
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.azure_subscription_id
}

# Create Azure AD Users
resource "azuread_user" "users" {
  for_each = var.users_list

  user_principal_name  = "${each.value.user_principal_name_prefix}@${each.value.domain}"
  display_name         = each.value.display_name
  mail                 = each.value.mail
  job_title            = each.value.job_title
  department           = each.value.department
  password             = var.default_password
  force_password_change = each.value.force_password_change
}

# Create Azure AD Groups
resource "azuread_group" "groups" {
  for_each = var.groups_list

  display_name     = each.value.display_name
  description      = each.value.description
  security_enabled = each.value.security_enabled
}

# Add Users to Groups
resource "azuread_group_member" "memberships" {
  for_each = {
    for idx, membership in var.group_memberships : "${membership.group_key}-${membership.user_key}" => membership
  }

  group_object_id  = azuread_group.groups[each.value.group_key].id
  member_object_id = azuread_user.users[each.value.user_key].id
}

# Create Resource Group for Role Assignments (if needed)
resource "azurerm_resource_group" "azuread_rg" {
  count = length([for assignment in var.role_assignments : assignment if assignment.scope_type == "resource_group"]) > 0 ? 1 : 0
  
  name     = var.resource_group_name
  location = "eastus"
}

# Create Role Assignments
resource "azurerm_role_assignment" "group_roles" {
  for_each = {
    for idx, assignment in var.role_assignments : "${assignment.group_key}-${assignment.role_name}" => assignment
  }

  principal_id   = azuread_group.groups[each.value.group_key].id
  role_definition_name = each.value.role_name
  
  # Determine the appropriate scope based on scope_type
  scope = each.value.scope_type == "subscription" ? "/subscriptions/${var.azure_subscription_id}" : (
    each.value.scope_type == "resource_group" ? azurerm_resource_group.azuread_rg[0].id : null
  )
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Providers

```terraform
provider "azuread" {
  tenant_id = var.tenant_id
}

provider "azurerm" {
  features {}
  tenant_id       = var.tenant_id
  subscription_id = var.azure_subscription_id
}
```

This configures both the Azure AD provider for identity management and the Azure RM provider for role assignments:
- The Azure AD provider uses the tenant_id to identify which directory to manage
- The Azure RM provider is needed for assigning roles to users/groups in Azure resources

### 2. Create Azure AD Users

```terraform
resource "azuread_user" "users" {
  for_each = var.users_list

  user_principal_name  = "${each.value.user_principal_name_prefix}@${each.value.domain}"
  display_name         = each.value.display_name
  mail                 = each.value.mail
  job_title            = each.value.job_title
  department           = each.value.department
  password             = var.default_password
  force_password_change = each.value.force_password_change
}
```

This creates users in Azure AD:
- Uses `for_each` to iterate through the `users_list` map
- Sets user attributes like name, email, and job details
- Assigns an initial password
- Can force password change on first login (recommended for security)

### 3. Create Azure AD Groups

```terraform
resource "azuread_group" "groups" {
  for_each = var.groups_list

  display_name     = each.value.display_name
  description      = each.value.description
  security_enabled = each.value.security_enabled
}
```

This creates security groups in Azure AD:
- Uses `for_each` to iterate through the `groups_list` map
- Sets group attributes like name and description
- Enables security features for RBAC

### 4. Add Users to Groups

```terraform
resource "azuread_group_member" "memberships" {
  for_each = {
    for idx, membership in var.group_memberships : "${membership.group_key}-${membership.user_key}" => membership
  }

  group_object_id  = azuread_group.groups[each.value.group_key].id
  member_object_id = azuread_user.users[each.value.user_key].id
}
```

This assigns users to groups:
- Creates a unique key for each membership to work with `for_each`
- References the IDs of groups and users created in previous steps
- Establishes the group membership relationships

### 5. Create Resource Group for Role Assignments

```terraform
resource "azurerm_resource_group" "azuread_rg" {
  count = length([for assignment in var.role_assignments : assignment if assignment.scope_type == "resource_group"]) > 0 ? 1 : 0
  
  name     = var.resource_group_name
  location = "eastus"
}
```

This conditionally creates a resource group if any role assignments require it:
- Only creates the resource group if there are assignments with "resource_group" scope
- Uses `count` to conditionally create the resource
- Sets the name and location of the resource group

### 6. Create Role Assignments

```terraform
resource "azurerm_role_assignment" "group_roles" {
  for_each = {
    for idx, assignment in var.role_assignments : "${assignment.group_key}-${assignment.role_name}" => assignment
  }

  principal_id   = azuread_group.groups[each.value.group_key].id
  role_definition_name = each.value.role_name
  
  # Determine the appropriate scope based on scope_type
  scope = each.value.scope_type == "subscription" ? "/subscriptions/${var.azure_subscription_id}" : (
    each.value.scope_type == "resource_group" ? azurerm_resource_group.azuread_rg[0].id : null
  )
}
```

This assigns Azure RBAC roles to groups:
- Creates a unique key for each role assignment to work with `for_each`
- References the group ID for the principal
- Sets the role definition name (built-in Azure roles like "Reader" or "Contributor")
- Sets the scope based on the scope_type:
  - Subscription-level scope: applies to entire subscription
  - Resource group-level scope: applies only to resources in the specified group

## Variables and Outputs

### Important Variables

- **tenant_id**: The Azure AD tenant ID where users and groups will be created
- **default_password**: The initial password for new users
- **users_list** and **groups_list**: Maps containing user and group details
- **group_memberships**: List of user-to-group membership relationships
- **role_assignments**: List of role assignments for groups

### Key Outputs

- **created_users** and **created_groups**: Details of the created resources
- **group_memberships**: Mapping of groups to their members
- **role_assignments**: Details of assigned roles and their scopes

## Common Issues and Solutions

1. **Access denied**: Ensure the account used has appropriate permissions (Global Admin or User Administrator)
2. **Role assignment failures**: Verify that the principal IDs and role names are correct
3. **Missing resources**: Check that all dependencies are properly referenced
4. **Invalid tenant_id**: Ensure the tenant_id is correct and the account has access

## Advanced Customizations

For more complex scenarios, consider:

1. Setting custom password policies:
```terraform
resource "azuread_directory_setting" "password_policy" {
  display_name = "Password Policy Settings"
  
  # Requires template ID for password settings
  template_id = "5cf42378-d67d-4f36-ba46-e8b86229381d"
  
  values = <<SETTINGS
    {
      "name": "PasswordPolicy.PasswordResetEnabled",
      "value": "true"
    }
  SETTINGS
}
```

2. Creating application registrations and service principals:
```terraform
resource "azuread_application" "example" {
  display_name = "ExampleApp"
  web {
    homepage_url = "https://example.com"
    redirect_uris = ["https://example.com/auth"]
  }
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}
```

3. Managing administrative unit scopes:
```terraform
resource "azuread_administrative_unit" "example" {
  display_name = "Finance Department"
  description  = "Administrative unit for Finance"
}

resource "azuread_administrative_unit_member" "example" {
  administrative_unit_id = azuread_administrative_unit.example.id
  member_id             = azuread_user.users["user1"].id
}
```

## Security Best Practices

1. **Enforce MFA**: Require multi-factor authentication for all users
2. **Least Privilege**: Assign the minimum necessary permissions
3. **Password Policies**: Enforce strong passwords and periodic changes
4. **Conditional Access**: Implement policies based on user, location, device
5. **Monitoring**: Enable Azure AD audit logs and alerts 