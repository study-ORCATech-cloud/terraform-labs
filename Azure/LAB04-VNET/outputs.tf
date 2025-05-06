# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.vnet_rg.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value = {
    for key, subnet in azurerm_subnet.subnets :
    key => subnet.id
  }
}

output "subnet_address_prefixes" {
  description = "Address prefixes of the created subnets"
  value = {
    for key, subnet in azurerm_subnet.subnets :
    key => subnet.address_prefixes
  }
}

output "nsg_ids" {
  description = "IDs of the created Network Security Groups"
  value = {
    for key, nsg in azurerm_network_security_group.nsgs :
    key => nsg.id
  }
}

output "nsg_rules" {
  description = "Security rules applied to the NSGs"
  value = {
    for key, rule in azurerm_network_security_rule.rules :
    key => {
      name                   = rule.name
      priority               = rule.priority
      direction              = rule.direction
      access                 = rule.access
      protocol               = rule.protocol
      destination_port_range = rule.destination_port_range
    }
  }
}

output "subnet_nsg_associations" {
  description = "Mapping of subnets to their associated NSGs"
  value = {
    for key, association in azurerm_subnet_network_security_group_association.associations :
    key => {
      subnet_id = association.subnet_id
      nsg_id    = association.network_security_group_id
    }
  }
}

output "peer_vnet_id" {
  description = "ID of the peer virtual network (if enabled)"
  value       = var.enable_vnet_peering ? azurerm_virtual_network.peer_vnet[0].id : null
}

output "peering_status" {
  description = "Status of VNet peering (if enabled)"
  value = var.enable_vnet_peering ? {
    vnet_to_peer = azurerm_virtual_network_peering.vnet_to_peer[0].peering_state
    peer_to_vnet = azurerm_virtual_network_peering.peer_to_vnet[0].peering_state
  } : "VNet peering not enabled"
} 
