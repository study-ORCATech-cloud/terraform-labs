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

# TODO: Create a Virtual Network
# Requirements:
# - Use azurerm_virtual_network resource
# - Set address_space using var.vnet_address_space
# - Reference the resource group you created

# TODO: Create a Subnet
# Requirements:
# - Use azurerm_subnet resource
# - Set address_prefixes using var.subnet_prefix
# - Reference the virtual network and resource group you created

# TODO: Create a Public IP Address
# Requirements:
# - Use azurerm_public_ip resource
# - Set allocation_method to "Dynamic" (or "Static" if you need a fixed IP)
# - Include any relevant tags

# TODO: Create a Network Interface (NIC)
# Requirements:
# - Use azurerm_network_interface resource
# - Create an ip_configuration block that references the subnet and public IP
# - Set private_ip_address_allocation to "Dynamic"

# TODO: Create a Network Security Group (NSG)
# Requirements:
# - Use azurerm_network_security_group resource
# - Create a security rule to allow SSH (port 22) access from Internet
# - Tag appropriately

# TODO: Associate the NSG with the NIC
# Requirements:
# - Use azurerm_network_interface_security_group_association resource
# - Reference the NIC and NSG you created

# TODO: Create an SSH Key (or use an existing one)
# Requirements:
# - Use tls_private_key resource if generating a new key
# - Set algorithm to "RSA" and rsa_bits to 4096

# TODO: Create a Virtual Machine
# Requirements:
# - Use azurerm_linux_virtual_machine resource
# - Set size using var.vm_size
# - Set admin_username using var.admin_username
# - Use source_image_reference to specify the VM image
# - Configure os_disk with caching, storage account type
# - Set disable_password_authentication to true
# - Configure admin_ssh_key with public key data
# - Reference the NIC you created 
