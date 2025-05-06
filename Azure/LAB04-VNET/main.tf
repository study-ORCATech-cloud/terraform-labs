# TODO: Configure the Azure Provider
# Requirements:
# - Set the features block
# - Use Azure Resource Manager (AzureRM)

provider "azurerm" {
  # TODO: Configure the features block with appropriate settings
  features {}
}

# TODO: Create a Resource Group
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create a Virtual Network
# Requirements:
# - Use azurerm_virtual_network resource
# - Set address_space using var.vnet_address_space
# - Set name using var.vnet_name
# - Reference the resource group you created
# - Apply tags using var.tags
# - Optionally set DNS servers if specified

# TODO: Create Multiple Subnets
# Requirements:
# - Use azurerm_subnet resource
# - Create subnets based on var.subnet_config
# - Use for_each to iterate through the subnet configurations
# - Set address_prefixes for each subnet
# - Reference the virtual network and resource group you created

# TODO: Create Network Security Groups
# Requirements:
# - Use azurerm_network_security_group resource
# - Create NSGs based on var.nsg_config
# - Use for_each to iterate through the NSG configurations
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create NSG Rules
# Requirements:
# - Use azurerm_network_security_rule resource
# - Create security rules based on var.nsg_rules
# - Use for_each to iterate through the security rules
# - Set priority, direction, access, protocol, port ranges, etc.
# - Reference the appropriate NSG created above

# TODO: Associate NSGs with Subnets
# Requirements:
# - Use azurerm_subnet_network_security_group_association resource
# - Associate NSGs with subnets based on var.nsg_subnet_associations
# - Use for_each to iterate through the associations
# - Reference the subnet IDs and NSG IDs created above

# TODO (Optional): Create a Second VNet for Peering
# Requirements:
# - Use azurerm_virtual_network resource
# - Set address_space using var.peer_vnet_address_space
# - Set name using var.peer_vnet_name
# - Only create if var.enable_vnet_peering is true
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO (Optional): Configure VNet Peering
# Requirements:
# - Use azurerm_virtual_network_peering resource
# - Create peering in both directions (vnet1->vnet2 and vnet2->vnet1)
# - Only create if var.enable_vnet_peering is true
# - Reference the virtual networks created above
# - Set allow_forwarded_traffic, allow_gateway_transit, use_remote_gateways as appropriate 
