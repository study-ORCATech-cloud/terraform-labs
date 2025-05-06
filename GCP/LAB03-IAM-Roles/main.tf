provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Create a custom IAM role
# Requirements:
# - Use var.custom_role_id for the role ID
# - Set the title to "Custom Terraform Role"
# - Set the description to "Custom role created via Terraform"
# - Include permissions from var.custom_role_permissions
# - Set stage to "GA" (Generally Available)

# TODO: Create a service account
# Requirements:
# - Use var.service_account_name for the account ID
# - Set a display name that includes "Terraform"
# - Add a description explaining the purpose
# - Set the service account to have a read-only role scope

# TODO: Assign the custom role to the service account at project level
# Requirements:
# - Create an IAM binding between the custom role and service account
# - Use the project-level binding (google_project_iam_member)

# TODO: Assign a predefined storage viewer role to the service account
# Requirements:
# - Use the "roles/storage.objectViewer" role
# - Create a project IAM binding for this predefined role

# TODO: (Optional) Create a conditional IAM binding if var.enable_conditional_binding is true
# Requirements:
# - Use count or dynamic blocks for conditional creation
# - Assign "roles/logging.viewer" to the service account
# - Use a condition that restricts access to a specific time period or resource pattern 
