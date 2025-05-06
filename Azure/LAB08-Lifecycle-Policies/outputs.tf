# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.lifecycle_rg.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.lifecycle_sa.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.lifecycle_sa.id
}

output "primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.lifecycle_sa.primary_access_key
  sensitive   = true
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = azurerm_storage_account.lifecycle_sa.primary_blob_endpoint
}

output "container_names" {
  description = "List of container names created"
  value       = [for container in azurerm_storage_container.containers : container.name]
}

output "lifecycle_policy_id" {
  description = "ID of the storage lifecycle management policy"
  value       = azurerm_storage_management_policy.lifecycle_policy.id
}

output "lifecycle_rules" {
  description = "List of lifecycle rules applied"
  value = [for rule in var.lifecycle_rules : {
    name                       = rule.name
    enabled                    = rule.enabled
    prefix_match               = rule.filters.prefix_match
    tier_to_cool_after_days    = rule.actions.tier_to_cool_after_days
    tier_to_archive_after_days = rule.actions.tier_to_archive_after_days
    delete_after_days          = rule.actions.delete_after_days
  }]
}

output "immutability_enabled" {
  description = "Whether immutability policy is enabled"
  value       = var.enable_immutability
}

output "immutability_policy_id" {
  description = "ID of the immutability policy (if enabled)"
  value       = var.enable_immutability ? azurerm_storage_container_immutability_policy.immutability[0].id : "No immutability policy enabled"
}

output "azure_portal_url" {
  description = "Azure portal URL to view the storage account"
  value       = "https://portal.azure.com/#resource${azurerm_storage_account.lifecycle_sa.id}/overview"
}

output "upload_test_file_command" {
  description = "Command to upload a test file to the storage account"
  value       = "az storage blob upload --account-name ${azurerm_storage_account.lifecycle_sa.name} --container-name documents --name test.txt --file ./test.txt --auth-mode key --account-key [YOUR_ACCOUNT_KEY]"
}

output "lifecycle_management_url" {
  description = "Azure portal URL to view the lifecycle management policy"
  value       = "https://portal.azure.com/#resource${azurerm_storage_account.lifecycle_sa.id}/lifecyclePolicies"
} 
