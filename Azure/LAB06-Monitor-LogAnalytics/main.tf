# TODO: Configure the Azure Provider
# Requirements:
# - Set the features block
# - Use Azure Resource Manager (AzureRM)

provider "azurerm" {
  # TODO: Configure the features block with appropriate settings
  features {}
}

# TODO: Create a Resource Group for monitoring resources
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create a Log Analytics Workspace
# Requirements:
# - Use azurerm_log_analytics_workspace resource
# - Set name using var.workspace_name
# - Set sku to "PerGB2018" (standard pricing tier)
# - Set retention_in_days to var.retention_days
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create a test Virtual Machine for monitoring purposes (optional)
# Requirements:
# - Only create this resource if var.create_test_vm is true
# - Use azurerm_linux_virtual_machine resource
# - Set name using var.vm_name
# - Configure with basic size (B1s or similar)
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Configure diagnostic settings for the VM
# Requirements:
# - Use azurerm_monitor_diagnostic_setting resource
# - Enable all available metrics
# - Send logs to the Log Analytics workspace you created
# - Only create this resource if var.create_test_vm is true

# TODO: Create a Metric Alert for the VM
# Requirements:
# - Use azurerm_monitor_metric_alert resource
# - Set name using var.alert_name
# - Set scopes to the VM resource ID
# - Configure criteria for CPU usage above var.cpu_threshold percentage
# - Set severity to var.alert_severity
# - Only create this resource if var.create_test_vm is true

# TODO: Create an Action Group for sending alert notifications
# Requirements:
# - Use azurerm_monitor_action_group resource
# - Set name using var.action_group_name
# - Configure email_receiver with name, email address from var.alert_email
# - Set short_name to a shortened version of the action group name
# - Reference the resource group you created

# TODO: Associate the Action Group with the Metric Alert
# Requirements:
# - Add action to the azurerm_monitor_metric_alert resource
# - Reference the action group you created

# TODO: Create a custom query (saved search) in Log Analytics
# Requirements:
# - Use azurerm_log_analytics_saved_search resource
# - Set name using var.query_name
# - Set category to "VM Insights"
# - Write a KQL query to find high CPU events
# - Reference the log analytics workspace you created 
