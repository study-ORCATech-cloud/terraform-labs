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

# TODO: Create a Subnet
# Requirements:
# - Use azurerm_subnet resource
# - Set address_prefixes using var.subnet_address_prefix
# - Set name using var.subnet_name
# - Reference the virtual network and resource group you created

# TODO: Create a Public IP for the Load Balancer
# Requirements:
# - Use azurerm_public_ip resource
# - Set allocation_method to "Static"
# - Set SKU to "Standard" to match the load balancer SKU
# - Set name using var.lb_public_ip_name
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create a Load Balancer
# Requirements:
# - Use azurerm_lb resource
# - Set SKU to "Standard"
# - Set name using var.lb_name
# - Configure frontend_ip_configuration block referencing the public IP
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create a Backend Address Pool
# Requirements:
# - Use azurerm_lb_backend_address_pool resource
# - Set name using var.lb_backend_pool_name
# - Reference the load balancer you created

# TODO: Create a Health Probe
# Requirements:
# - Use azurerm_lb_probe resource
# - Set protocol to "Http" (or use var.lb_probe_protocol)
# - Set port to 80 (or use var.lb_probe_port)
# - Set request_path to "/"
# - Set interval_in_seconds and number_of_probes
# - Set name using var.lb_probe_name
# - Reference the load balancer you created

# TODO: Create a Load Balancing Rule
# Requirements:
# - Use azurerm_lb_rule resource
# - Set protocol to "Tcp" (or use var.lb_rule_protocol)
# - Set frontend_port and backend_port to 80 (or use variables)
# - Set name using var.lb_rule_name
# - Reference the frontend IP configuration, backend address pool, and probe you created
# - Reference the load balancer you created

# TODO: Create a Network Security Group
# Requirements:
# - Use azurerm_network_security_group resource
# - Set name using var.nsg_name
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create NSG Rules
# Requirements:
# - Use azurerm_network_security_rule resource
# - Create a rule to allow HTTP traffic on port 80
# - Create a rule to allow SSH traffic on port 22 (for management)
# - Reference the network security group you created

# TODO: Create a VM Scale Set
# Requirements:
# - Use azurerm_linux_virtual_machine_scale_set resource
# - Set name using var.vmss_name
# - Set instances to var.vmss_instances
# - Configure sku with var.vmss_sku
# - Set admin_username using var.admin_username
# - Configure admin_ssh_key with public key data
# - Configure os_disk with caching, storage_account_type
# - Configure source_image_reference with publisher, offer, sku, version
# - Configure network_interface with name, primary, and ip_configuration
# - Set health_probe_id to the health probe you created
# - Reference the resource group, subnet, backend address pool, and network security group
# - Apply tags using var.tags
# - Set custom_data to render a basic web page (use var.custom_data_script or filebase64 function)

# TODO (Optional): Configure Autoscaling for the VM Scale Set
# Requirements:
# - Use azurerm_monitor_autoscale_setting resource
# - Set name using var.autoscale_name
# - Configure profile with capacity (min, max, default)
# - Configure rules for scaling out (e.g., when CPU > 75%)
# - Configure rules for scaling in (e.g., when CPU < 25%)
# - Reference the resource group and VM scale set you created
# - Only implement this if var.enable_autoscaling is true 
