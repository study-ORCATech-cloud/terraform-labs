# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# TODO: Create a Resource Group for Function App resources
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create a Storage Account for Function App
# Requirements:
# - Use azurerm_storage_account resource
# - Set unique name using var.storage_account_name
# - Set account_tier to "Standard"
# - Set account_replication_type to "LRS"
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create a Service Plan for Function App
# Requirements:
# - Use azurerm_service_plan resource
# - Set name using var.service_plan_name
# - Set os_type to "Linux" or "Windows" (based on var.os_type)
# - Set sku_name to "Y1" for consumption plan
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create an Application Insights instance (optional but recommended)
# Requirements:
# - Use azurerm_application_insights resource
# - Set name using var.app_insights_name
# - Set application_type to "web"
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create a Linux Function App
# Requirements:
# - Use azurerm_linux_function_app or azurerm_windows_function_app resource (based on var.os_type)
# - Set name using var.function_app_name
# - Reference the resource group, storage account, and service plan you created
# - Configure the following site_config settings:
#   - application_stack with node_version, python_version, or dotnet_version based on var.function_runtime
# - Set https_only to true
# - Set app_settings with:
#   - "WEBSITE_RUN_FROM_PACKAGE" = "1"
#   - "FUNCTIONS_WORKER_RUNTIME" = var.function_runtime
#   - "APPINSIGHTS_INSTRUMENTATIONKEY" = reference to app insights key
# - Apply tags using var.tags

# TODO: Deploy the Function code using the zip_deploy_file
# Requirements:
# - Use azurerm_function_app_function or null_resource with local-exec
# - Ensure the function.zip file is properly deployed
# - Set the function name using var.function_name
# - Set the trigger configuration based on HTTP trigger
# - Configure authentication level (anonymous or function) 
