# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.function_rg.name
}

output "function_app_name" {
  description = "Name of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].name : azurerm_windows_function_app.function_app[0].name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].default_hostname : azurerm_windows_function_app.function_app[0].default_hostname
}

output "function_app_id" {
  description = "ID of the Function App"
  value       = var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].id : azurerm_windows_function_app.function_app[0].id
}

output "function_url" {
  description = "URL to access the HTTP triggered function"
  value       = "https://${var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].default_hostname : azurerm_windows_function_app.function_app[0].default_hostname}/api/${var.function_name}"
}

output "function_key_instructions" {
  description = "Instructions to get function key for authentication"
  value       = var.auth_level == "function" ? "To get your function key, run: az functionapp function keys list --name ${var.function_app_name} --resource-group ${azurerm_resource_group.function_rg.name} --function-name ${var.function_name}" : "No function key required - anonymous access enabled"
}

output "application_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.insights.instrumentation_key
  sensitive   = true
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.function_storage.name
}

output "invoke_function_example" {
  description = "Example command to invoke the HTTP triggered function"
  value       = var.auth_level == "function" ? "curl 'https://${var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].default_hostname : azurerm_windows_function_app.function_app[0].default_hostname}/api/${var.function_name}?code=<function_key>&name=Terraform'" : "curl 'https://${var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].default_hostname : azurerm_windows_function_app.function_app[0].default_hostname}/api/${var.function_name}?name=Terraform'"
}

output "azure_portal_url" {
  description = "Azure portal URL to view the Function App"
  value       = "https://portal.azure.com/#resource/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${azurerm_resource_group.function_rg.name}/providers/Microsoft.Web/sites/${var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].name : azurerm_windows_function_app.function_app[0].name}/functionsMenu"
} 
