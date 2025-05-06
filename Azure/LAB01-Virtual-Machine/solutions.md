# LAB01: Virtual Machine in Azure Solution

This document provides solutions for the Virtual Machine lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "vm_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a virtual network
resource "azurerm_virtual_network" "vm_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags
}

# Create a subnet
resource "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vm_rg.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = var.subnet_prefix
}

# Create a public IP address
resource "azurerm_public_ip" "vm_pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}

# Create a network interface
resource "azurerm_network_interface" "vm_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

# Create a network security group
resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags
}

# Create a security rule for SSH
resource "azurerm_network_security_rule" "vm_nsg_rule" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vm_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Create SSH key
resource "tls_private_key" "ssh_key" {
  count     = var.generate_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.vm_rg.location
  resource_group_name   = azurerm_resource_group.vm_rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  tags                  = var.tags

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.generate_ssh_key ? tls_private_key.ssh_key[0].public_key_openssh : file(var.ssh_public_key_path)
  }

  disable_password_authentication = true
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Provider

```terraform
provider "azurerm" {
  features {}
}
```

This configures the Azure Resource Manager provider. The empty `features {}` block is required by the provider, and it can contain specific feature flags if needed.

### 2. Create a Resource Group

```terraform
resource "azurerm_resource_group" "vm_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for related Azure resources:
- Sets the name using the variable `resource_group_name`
- Sets the location (Azure region) using the variable `location`
- Applies tags defined in the `tags` variable for better organization

### 3. Create a Virtual Network and Subnet

```terraform
resource "azurerm_virtual_network" "vm_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vm_rg.name
  virtual_network_name = azurerm_virtual_network.vm_vnet.name
  address_prefixes     = var.subnet_prefix
}
```

These resources create a virtual network and subnet:
- The virtual network defines the overall network address space (e.g., `10.0.0.0/16`)
- The subnet defines a portion of that address space (e.g., `10.0.1.0/24`)
- Both resources reference the resource group created earlier

### 4. Create Public IP and Network Interface

```terraform
resource "azurerm_public_ip" "vm_pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_network_interface" "vm_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}
```

These resources create a public IP address and network interface:
- The public IP allows external access to the VM
- The network interface connects the VM to the virtual network
- The IP configuration specifies both a private IP (in the subnet) and a public IP

### 5. Create Network Security Group and Rules

```terraform
resource "azurerm_network_security_group" "vm_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "vm_nsg_rule" {
  name                        = "AllowSSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vm_rg.name
  network_security_group_name = azurerm_network_security_group.vm_nsg.name
}

resource "azurerm_network_interface_security_group_association" "vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
```

These resources create a network security group (NSG) with a rule to allow SSH access:
- The NSG acts as a virtual firewall
- The security rule allows inbound TCP traffic on port 22 (SSH)
- The association links the NSG to the network interface created earlier

### 6. Generate SSH Key

```terraform
resource "tls_private_key" "ssh_key" {
  count     = var.generate_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

This conditionally generates an SSH key pair if `generate_ssh_key` is set to true:
- Uses RSA with 4096 bits for strong security
- The count parameter makes this resource optional

### 7. Create a Linux Virtual Machine

```terraform
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = azurerm_resource_group.vm_rg.location
  resource_group_name   = azurerm_resource_group.vm_rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  size                  = var.vm_size
  admin_username        = var.admin_username
  tags                  = var.tags

  os_disk {
    name                 = var.os_disk_name
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.generate_ssh_key ? tls_private_key.ssh_key[0].public_key_openssh : file(var.ssh_public_key_path)
  }

  disable_password_authentication = true
}
```

This creates the virtual machine:
- References the network interface and resource group
- Sets the VM size, which determines CPU, memory, and disk capabilities
- Configures the OS disk with caching and storage type
- Specifies the VM image using publisher, offer, sku, and version
- Configures SSH authentication using either the generated key or an existing key
- Disables password authentication for better security

## Variables and Outputs

### Important Variables

- **resource_group_name**, **location**: Define where resources are deployed
- **vnet_address_space**, **subnet_prefix**: Define network topology
- **vm_size**: Determines VM performance and cost
- **source_image_***: Define the VM operating system
- **generate_ssh_key**: Controls whether to generate a new SSH key or use an existing one

### Key Outputs

- **public_ip_address**: The public IP address to connect to the VM
- **ssh_connection_string**: A ready-to-use SSH command
- **generated_ssh_private_key**: The private key if a new one was generated

## Common Issues and Solutions

1. **VM deployment fails**: Check resource group location compatibility with VM size
2. **Cannot SSH to VM**: Ensure NSG rules allow port 22 from your IP address
3. **SSH access fails**: Verify you're using the correct private key and username
4. **Slow deployment**: Some VM sizes or regions may have longer provisioning times

## Advanced Customizations

For more complex deployments, consider:

1. Limiting SSH access to specific IP addresses:
```terraform
resource "azurerm_network_security_rule" "vm_nsg_rule_ssh" {
  # ... other configuration ...
  source_address_prefix       = "123.123.123.123/32"  # Your specific IP
  # ... other configuration ...
}
```

2. Adding a data disk for additional storage:
```terraform
resource "azurerm_managed_disk" "data_disk" {
  name                 = "${var.vm_name}-data-disk"
  location             = azurerm_resource_group.vm_rg.location
  resource_group_name  = azurerm_resource_group.vm_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}
```

3. Setting up a Windows VM instead of Linux:
```terraform
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.vm_name
  # ... other configuration ...
  admin_password        = "ComplexPassword123!"
  
  os_disk {
    # ... disk configuration ...
  }
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
``` 