# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.monitoring_rg.name
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.workspace.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.workspace.name
}

output "log_analytics_portal_url" {
  description = "URL to access the Log Analytics workspace in Azure Portal"
  value       = "https://portal.azure.com/#blade/Microsoft_OperationsManagementSuite_Workspace/AnalyticsBlade/overview/id/${azurerm_log_analytics_workspace.workspace.id}"
}

output "test_vm_id" {
  description = "ID of the test VM (if created)"
  value       = var.create_test_vm ? azurerm_linux_virtual_machine.test_vm[0].id : "No test VM created"
}

output "alert_id" {
  description = "ID of the CPU alert (if test VM was created)"
  value       = var.create_test_vm ? azurerm_monitor_metric_alert.cpu_alert[0].id : "No alert created"
}

output "action_group_id" {
  description = "ID of the action group"
  value       = azurerm_monitor_action_group.email_action_group.id
}

output "saved_query_id" {
  description = "ID of the saved Log Analytics query"
  value       = azurerm_log_analytics_saved_search.high_cpu_query.id
}

output "monitoring_instructions" {
  description = "Instructions for testing the monitoring setup"
  value       = <<EOF
To test the monitoring setup:

1. If you created a test VM, generate CPU load by running: 
   az vm run-command invoke --resource-group ${azurerm_resource_group.monitoring_rg.name} --name ${var.create_test_vm ? azurerm_linux_virtual_machine.test_vm[0].name : "no-vm"} --command-id RunShellScript --scripts "apt-get update && apt-get install -y stress && stress --cpu 8 --timeout 600"

2. View metrics in Azure Portal:
   ${local.azure_portal_metric_url}

3. Check for alerts in Azure Portal:
   https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/alertsV2

4. Run custom queries in Log Analytics:
   ${log_analytics_portal_url}
EOF
}

# Local values for constructing URLs
locals {
  azure_portal_metric_url = var.create_test_vm ? "https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/AzureMonitoringBrowseBlade/metrics/resourceId/${azurerm_linux_virtual_machine.test_vm[0].id}" : "No VM metrics URL available"
}
