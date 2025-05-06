# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "created_users" {
  description = "Details of the created Azure AD users"
  value = {
    for key, user in azuread_user.users :
    key => {
      id                  = user.id
      display_name        = user.display_name
      user_principal_name = user.user_principal_name
      mail                = user.mail
    }
  }
}

output "created_groups" {
  description = "Details of the created Azure AD groups"
  value = {
    for key, group in azuread_group.groups :
    key => {
      id           = group.id
      display_name = group.display_name
      description  = group.description
    }
  }
}

output "group_memberships" {
  description = "Map of groups to their members"
  value = {
    for key, group in azuread_group.groups :
    group.display_name => {
      members = [
        for membership in azuread_group_member.memberships :
        azuread_user.users[membership.member_object_id].display_name
        if membership.group_object_id == group.id
      ]
    }
  }
}

output "role_assignments" {
  description = "Details of role assignments (if implemented)"
  value = try({
    for key, assignment in azurerm_role_assignment.group_roles :
    key => {
      group_name = azuread_group.groups[key].display_name
      role_name  = assignment.role_definition_name
      scope      = assignment.scope
    }
  }, "No role assignments implemented")
} 
