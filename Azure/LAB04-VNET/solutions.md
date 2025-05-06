# LAB04: Azure Virtual Network Solution

This document provides solutions for the Azure Virtual Network lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "vnet_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = var.vnet_address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null
  tags                = var.tags
}

# Create multiple subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_config

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}

# Create network security groups
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.nsg_config

  name                = each.value.name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags                = var.tags
}

# Create NSG rules
resource "azurerm_network_security_rule" "rules" {
  for_each = var.nsg_rules

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  description                 = each.value.description
  resource_group_name         = azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.value.nsg_key].name
}

# Associate NSGs with subnets
resource "azurerm_subnet_network_security_group_association" "associations" {
  for_each = var.nsg_subnet_associations

  subnet_id                 = azurerm_subnet.subnets[each.value.subnet_key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_key].id
}

# Create a second VNet for peering (optional)
resource "azurerm_virtual_network" "peer_vnet" {
  count = var.enable_vnet_peering ? 1 : 0

  name                = var.peer_vnet_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = var.peer_vnet_address_space
  tags                = var.tags
}

# Configure VNet peering from primary to peer
resource "azurerm_virtual_network_peering" "vnet_to_peer" {
  count = var.enable_vnet_peering ? 1 : 0

  name                      = "${var.vnet_name}-to-${var.peer_vnet_name}"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.peer_vnet[0].id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

# Configure VNet peering from peer to primary
resource "azurerm_virtual_network_peering" "peer_to_vnet" {
  count = var.enable_vnet_peering ? 1 : 0

  name                      = "${var.peer_vnet_name}-to-${var.vnet_name}"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.peer_vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Provider

```terraform
provider "azurerm" {
  features {}
}
```

This configures the Azure Resource Manager provider. The `features {}` block is required by the provider and can contain specific feature flags if needed.

### 2. Create a Resource Group

```terraform
resource "azurerm_resource_group" "vnet_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for related Azure resources:
- Sets the name using the variable `resource_group_name`
- Sets the location (Azure region) using the variable `location`
- Applies tags defined in the `tags` variable for better organization

### 3. Create a Virtual Network

```terraform
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = var.vnet_address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null
  tags                = var.tags
}
```

This creates a virtual network (VNet):
- Sets the name, location, and resource group
- Configures the address space (e.g., "10.0.0.0/16")
- Conditionally sets DNS servers if any are specified
- Applies tags for better resource management

### 4. Create Multiple Subnets

```terraform
resource "azurerm_subnet" "subnets" {
  for_each = var.subnet_config

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}
```

This creates multiple subnets within the virtual network:
- Uses `for_each` to iterate through the `subnet_config` map
- Creates subnets with the specified names and address prefixes
- Configures service endpoints for connecting to Azure services
- Associates each subnet with the virtual network and resource group

### 5. Create Network Security Groups

```terraform
resource "azurerm_network_security_group" "nsgs" {
  for_each = var.nsg_config

  name                = each.value.name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  tags                = var.tags
}
```

This creates network security groups (NSGs):
- Uses `for_each` to iterate through the `nsg_config` map
- Creates NSGs with the specified names
- Sets the location and resource group
- Applies tags for better resource management

### 6. Create NSG Rules

```terraform
resource "azurerm_network_security_rule" "rules" {
  for_each = var.nsg_rules

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  description                 = each.value.description
  resource_group_name         = azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.nsgs[each.value.nsg_key].name
}
```

This creates security rules for the NSGs:
- Uses `for_each` to iterate through the `nsg_rules` map
- Configures various properties for each rule, such as priority, direction, access, protocol, port ranges, and address prefixes
- Associates each rule with the appropriate NSG using the `nsg_key` property

### 7. Associate NSGs with Subnets

```terraform
resource "azurerm_subnet_network_security_group_association" "associations" {
  for_each = var.nsg_subnet_associations

  subnet_id                 = azurerm_subnet.subnets[each.value.subnet_key].id
  network_security_group_id = azurerm_network_security_group.nsgs[each.value.nsg_key].id
}
```

This associates NSGs with subnets:
- Uses `for_each` to iterate through the `nsg_subnet_associations` map
- Links each subnet to its corresponding NSG
- Uses the `subnet_key` and `nsg_key` properties to reference the correct resources

### 8. Create a Second VNet for Peering (Optional)

```terraform
resource "azurerm_virtual_network" "peer_vnet" {
  count = var.enable_vnet_peering ? 1 : 0

  name                = var.peer_vnet_name
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = var.peer_vnet_address_space
  tags                = var.tags
}
```

This conditionally creates a second virtual network for peering:
- Uses the `count` parameter to create the resource only if `enable_vnet_peering` is true
- Configures the peer VNet with a different name and address space
- Places it in the same resource group and location as the primary VNet

### 9. Configure VNet Peering

```terraform
resource "azurerm_virtual_network_peering" "vnet_to_peer" {
  count = var.enable_vnet_peering ? 1 : 0

  name                      = "${var.vnet_name}-to-${var.peer_vnet_name}"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.peer_vnet[0].id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "peer_to_vnet" {
  count = var.enable_vnet_peering ? 1 : 0

  name                      = "${var.peer_vnet_name}-to-${var.vnet_name}"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.peer_vnet[0].name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false
}
```

This sets up bidirectional VNet peering:
- Creates peering connections in both directions (primary-to-peer and peer-to-primary)
- Uses the `count` parameter to create the resources only if `enable_vnet_peering` is true
- Configures peering properties like allowing virtual network access and forwarded traffic
- Sets the appropriate remote virtual network IDs

## Variables and Outputs

### Important Variables

- **vnet_address_space**: Defines the overall IP range for the virtual network
- **subnet_config**: Map of subnet configurations with name, address prefixes, and service endpoints
- **nsg_rules**: Map of security rules for controlling traffic
- **nsg_subnet_associations**: Map defining which NSGs protect which subnets
- **enable_vnet_peering**: Boolean flag to enable or disable VNet peering

### Key Outputs

- **vnet_id** and **subnet_ids**: Resource IDs for the created networking components
- **nsg_rules**: Details of the security rules applied to each NSG
- **peering_status**: Status of the VNet peering connections (if enabled)

## Common Issues and Solutions

1. **Address space conflicts**: Ensure subnet address ranges don't overlap and are within the VNet's address space
2. **NSG rule priorities**: Each NSG rule must have a unique priority value within its NSG
3. **Service endpoint compatibility**: Not all Azure services support service endpoints in all regions
4. **VNet peering limitations**: VNet address spaces cannot overlap when peering

## Advanced Customizations

For more complex deployments, consider:

1. Creating service delegation for specific Azure services:
```terraform
resource "azurerm_subnet" "delegated_subnet" {
  name                 = "delegated-subnet"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
  
  delegation {
    name = "delegation"
    
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
```

2. Configuring a more comprehensive network security rule:
```terraform
resource "azurerm_network_security_rule" "advanced_rule" {
  name                         = "advanced-rule"
  priority                     = 200
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "*"
  source_port_ranges           = ["1024-65535"]
  destination_port_ranges      = ["80", "443"]
  source_address_prefixes      = ["192.168.1.0/24", "10.0.0.0/24"]
  destination_address_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]
  resource_group_name          = azurerm_resource_group.vnet_rg.name
  network_security_group_name  = azurerm_network_security_group.nsgs["web"].name
}
```

3. Implementing a hub-and-spoke network topology:
```terraform
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network" "spoke_vnet_1" {
  name                = "spoke-vnet-1"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_virtual_network" "spoke_vnet_2" {
  name                = "spoke-vnet-2"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = ["10.2.0.0/16"]
}

# Peering from hub to spoke 1
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                      = "hub-to-spoke1"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet_1.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

# Peering from spoke 1 to hub
resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                      = "spoke1-to-hub"
  resource_group_name       = azurerm_resource_group.vnet_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet_1.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
  use_remote_gateways       = true
}

# Additional peerings would be created for spoke 2
```

## Security Best Practices

1. **Principle of Least Privilege**: Define NSG rules that grant only the minimum required access
2. **Segment Networks Appropriately**: Use subnets to isolate different tiers of applications
3. **Secure Administrative Access**: Use Azure Bastion or jump boxes for secure administrative access
4. **Monitor Network Traffic**: Use Network Watcher and flow logs to monitor traffic
5. **Use Service Endpoints and Private Links**: Securely connect to Azure services without traversing the public internet 