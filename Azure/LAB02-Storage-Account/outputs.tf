# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.storage_rg.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "primary_blob_endpoint" {
  description = "The blob endpoint URL of the storage account"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "blob_container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.blob_container.name
}

output "blob_container_url" {
  description = "URL of the blob container"
  value       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.blob_container.name}"
}

output "static_website_enabled" {
  description = "Whether static website hosting is enabled"
  value       = var.enable_static_website
}

output "static_website_url" {
  description = "URL of the static website (if enabled)"
  value       = var.enable_static_website ? azurerm_storage_account.storage_account.primary_web_endpoint : "Static website hosting not enabled"
}

output "primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}

output "connection_string" {
  description = "Connection string for the storage account"
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
} 
