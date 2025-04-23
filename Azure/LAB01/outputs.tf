output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.example.id
}

output "virtual_network_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.example.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = azurerm_subnet.example.id
} 
