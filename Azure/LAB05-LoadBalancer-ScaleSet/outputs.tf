# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.vmss_rg.name
}

output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.lb_public_ip.ip_address
}

output "load_balancer_url" {
  description = "URL to access the load-balanced application"
  value       = "http://${azurerm_public_ip.lb_public_ip.ip_address}"
}

output "vmss_id" {
  description = "ID of the VM scale set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.id
}

output "vmss_name" {
  description = "Name of the VM scale set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.name
}

output "vmss_instances" {
  description = "Number of VM instances in the scale set"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.instances
}

output "vmss_admin_username" {
  description = "Admin username for VM instances"
  value       = azurerm_linux_virtual_machine_scale_set.vmss.admin_username
}

output "autoscaling_enabled" {
  description = "Whether autoscaling is enabled for the VM scale set"
  value       = var.enable_autoscaling
}

output "backend_address_pool_id" {
  description = "ID of the backend address pool"
  value       = azurerm_lb_backend_address_pool.backend_pool.id
}

output "health_probe_id" {
  description = "ID of the health probe"
  value       = azurerm_lb_probe.http_probe.id
}

output "load_balancing_rule_id" {
  description = "ID of the load balancing rule"
  value       = azurerm_lb_rule.http_rule.id
}

output "scale_out_threshold" {
  description = "CPU threshold for scaling out (if autoscaling is enabled)"
  value       = var.enable_autoscaling ? var.scale_out_cpu_threshold : "Autoscaling not enabled"
}

output "scale_in_threshold" {
  description = "CPU threshold for scaling in (if autoscaling is enabled)"
  value       = var.enable_autoscaling ? var.scale_in_cpu_threshold : "Autoscaling not enabled"
}

output "ssh_command" {
  description = "Note: You cannot directly SSH to scale set instances via the load balancer. Use VM Scale Set extension in Azure Portal to access instances."
  value       = "Access individual VM instances through Azure Portal > VM Scale Set > Instances > Connect"
} 
