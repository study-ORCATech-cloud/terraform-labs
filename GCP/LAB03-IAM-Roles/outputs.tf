# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "custom_role_id" {
  description = "The ID of the custom IAM role"
  value       = google_project_iam_custom_role.custom_role.id
}

output "custom_role_name" {
  description = "The name of the custom IAM role"
  value       = google_project_iam_custom_role.custom_role.name
}

output "custom_role_permissions" {
  description = "The permissions included in the custom role"
  value       = google_project_iam_custom_role.custom_role.permissions
}

output "service_account_email" {
  description = "The email address of the service account"
  value       = google_service_account.service_account.email
}

output "service_account_name" {
  description = "The fully-qualified name of the service account"
  value       = google_service_account.service_account.name
}

output "service_account_id" {
  description = "The unique ID of the service account"
  value       = google_service_account.service_account.unique_id
}

output "role_bindings" {
  description = "List of role bindings created"
  value = [
    "Custom role: ${google_project_iam_member.custom_role_binding.role} -> ${google_project_iam_member.custom_role_binding.member}",
    "Storage viewer: roles/storage.objectViewer -> ${google_project_iam_member.storage_viewer_binding.member}"
  ]
}

output "conditional_binding" {
  description = "Conditional IAM binding (if enabled)"
  value       = var.enable_conditional_binding ? "Logging viewer with condition: ${var.conditional_expression}" : "No conditional binding enabled"
}

output "gcloud_get_iam_policy" {
  description = "Command to view the project's IAM policy"
  value       = "gcloud projects get-iam-policy ${var.project_id} --format=json"
}

output "gcloud_service_account_info" {
  description = "Command to view service account details"
  value       = "gcloud iam service-accounts describe ${google_service_account.service_account.email}"
} 
