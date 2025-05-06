# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.vm_rg.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.vm_rg.location
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vm_vnet.name
}

output "virtual_network_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.vm_vnet.address_space
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = azurerm_subnet.vm_subnet.name
}

output "subnet_address_prefix" {
  description = "Address prefix of the subnet"
  value       = azurerm_subnet.vm_subnet.address_prefixes
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.vm_pip.ip_address
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_size" {
  description = "Size of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.size
}

output "vm_admin_username" {
  description = "Admin username of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

output "ssh_connection_string" {
  description = "Command to connect to the VM via SSH"
  value       = "ssh ${azurerm_linux_virtual_machine.vm.admin_username}@${azurerm_public_ip.vm_pip.ip_address}"
}

output "generated_ssh_private_key" {
  description = "The generated private key (only shown when generating a new key)"
  value       = var.generate_ssh_key ? nonsensitive(tls_private_key.ssh_key[0].private_key_pem) : "Using existing SSH key"
  sensitive   = false
}

output "nsg_rules" {
  description = "Security rules applied to the VM"
  value = {
    for rule in azurerm_network_security_rule.vm_nsg_rule :
    rule.name => {
      priority = rule.priority
      port     = rule.destination_port_range
      protocol = rule.protocol
    }
  }
} 
