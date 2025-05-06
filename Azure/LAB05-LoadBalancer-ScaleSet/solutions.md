# LAB05: Azure Load Balancer and VM Scale Set Solution

This document provides solutions for the Azure Load Balancer and VM Scale Set lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "vmss_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vmss_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

# Create a public IP for the load balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = var.lb_public_ip_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create a load balancer
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = var.lb_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Create a backend address pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = var.lb_backend_pool_name
  loadbalancer_id = azurerm_lb.lb.id
}

# Create a health probe
resource "azurerm_lb_probe" "http_probe" {
  name                = var.lb_probe_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = var.lb_probe_protocol
  port                = var.lb_probe_port
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
  request_path        = "/"
}

# Create a load balancing rule
resource "azurerm_lb_rule" "http_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = var.lb_rule_protocol
  frontend_port                  = var.lb_rule_frontend_port
  backend_port                   = var.lb_rule_backend_port
  frontend_ip_configuration_name = var.lb_frontend_ip_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
  enable_floating_ip             = false
  disable_outbound_snat          = true
  enable_tcp_reset               = true
  idle_timeout_in_minutes        = 15
}

# Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  tags                = var.tags
}

# Create NSG rules
resource "azurerm_network_security_rule" "http_rule" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vmss_rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "allow-ssh"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vmss_rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Create a VM scale set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = azurerm_resource_group.vmss_rg.name
  location            = azurerm_resource_group.vmss_rg.location
  sku                 = var.vmss_sku
  instances           = var.vmss_instances
  admin_username      = var.admin_username
  tags                = var.tags
  
  custom_data = base64encode(var.custom_data_script)

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
    }
  }

  health_probe_id = azurerm_lb_probe.http_probe.id
}

# Optional: Configure autoscaling for the VM scale set
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = var.autoscale_name
  resource_group_name = azurerm_resource_group.vmss_rg.name
  location            = azurerm_resource_group.vmss_rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "AutoScale"

    capacity {
      default = var.autoscale_default_instances
      minimum = var.autoscale_min_instances
      maximum = var.autoscale_max_instances
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Provider

```terraform
provider "azurerm" {
  features {}
}
```

This configures the Azure Resource Manager provider. The empty `features {}` block is required by the provider.

### 2. Create a Resource Group

```terraform
resource "azurerm_resource_group" "vmss_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for all the resources in this lab:
- Sets the name using the variable `resource_group_name`
- Sets the location (Azure region) using the variable `location`
- Applies tags defined in the `tags` variable for better organization

### 3. Create a Virtual Network and Subnet

```terraform
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vmss_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}
```

This creates the network infrastructure:
- A virtual network with the specified address space (e.g., `10.0.0.0/16`)
- A subnet within the VNet with the specified address prefix (e.g., `10.0.1.0/24`)

### 4. Create Load Balancer Components

```terraform
# Create a public IP for the load balancer
resource "azurerm_public_ip" "lb_public_ip" {
  name                = var.lb_public_ip_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create a load balancer
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  sku                 = "Standard"
  tags                = var.tags

  frontend_ip_configuration {
    name                 = var.lb_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}

# Create a backend address pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = var.lb_backend_pool_name
  loadbalancer_id = azurerm_lb.lb.id
}

# Create a health probe
resource "azurerm_lb_probe" "http_probe" {
  name                = var.lb_probe_name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = var.lb_probe_protocol
  port                = var.lb_probe_port
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
  request_path        = "/"
}

# Create a load balancing rule
resource "azurerm_lb_rule" "http_rule" {
  name                           = var.lb_rule_name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = var.lb_rule_protocol
  frontend_port                  = var.lb_rule_frontend_port
  backend_port                   = var.lb_rule_backend_port
  frontend_ip_configuration_name = var.lb_frontend_ip_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
  enable_floating_ip             = false
  disable_outbound_snat          = true
  enable_tcp_reset               = true
  idle_timeout_in_minutes        = 15
}
```

This creates the load balancer components:
- A public IP with static allocation for the load balancer
- A Standard SKU load balancer with a frontend IP configuration linked to the public IP
- A backend address pool where VM instances will be placed
- A health probe to check if instances are healthy (HTTP probe checking port 80)
- A load balancing rule to direct traffic from the frontend to the backend pool

### 5. Create Network Security Group

```terraform
# Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  tags                = var.tags
}

# Create NSG rules
resource "azurerm_network_security_rule" "http_rule" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vmss_rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "allow-ssh"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vmss_rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
```

This configures the network security:
- Creates a network security group
- Adds a rule to allow HTTP traffic (port 80) for the web application
- Adds a rule to allow SSH traffic (port 22) for administrative access

### 6. Create a VM Scale Set

```terraform
# Create a VM scale set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = var.vmss_name
  resource_group_name = azurerm_resource_group.vmss_rg.name
  location            = azurerm_resource_group.vmss_rg.location
  sku                 = var.vmss_sku
  instances           = var.vmss_instances
  admin_username      = var.admin_username
  tags                = var.tags
  
  custom_data = base64encode(var.custom_data_script)

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = var.source_image_publisher
    offer     = var.source_image_offer
    sku       = var.source_image_sku
    version   = var.source_image_version
  }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.backend_pool.id]
    }
  }

  health_probe_id = azurerm_lb_probe.http_probe.id
}
```

This creates the VM Scale Set:
- Sets the name, size (SKU), and initial instance count
- Configures the admin username and SSH key for access
- Uses custom data script to install and configure NGINX on each instance
- Specifies the source image (Ubuntu Server 18.04 LTS)
- Configures the OS disk with caching and storage type
- Sets up a network interface that connects to the subnet
- Associates the scale set with the load balancer backend pool
- Configures health monitoring using the health probe

### 7. Configure Autoscaling (Optional)

```terraform
# Optional: Configure autoscaling for the VM scale set
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count               = var.enable_autoscaling ? 1 : 0
  name                = var.autoscale_name
  resource_group_name = azurerm_resource_group.vmss_rg.name
  location            = azurerm_resource_group.vmss_rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.vmss.id

  profile {
    name = "AutoScale"

    capacity {
      default = var.autoscale_default_instances
      minimum = var.autoscale_min_instances
      maximum = var.autoscale_max_instances
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.scale_out_cpu_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.vmss.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.scale_in_cpu_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
```

This configures automatic scaling for the VM Scale Set:
- Only created if `enable_autoscaling` is set to true
- Sets capacity limits (minimum, maximum, and default instance counts)
- Creates a scale-out rule to add an instance when average CPU exceeds the threshold
- Creates a scale-in rule to remove an instance when average CPU is below the threshold
- Uses cooldown periods to prevent rapid scaling

## Variables and Outputs

### Important Variables

- **vmss_instances**: Initial number of VM instances in the scale set
- **vmss_sku**: Size of the VM instances (affects cost and performance)
- **custom_data_script**: Script to install and configure software on instances
- **enable_autoscaling**: Boolean flag to enable or disable auto-scaling
- **scale_out_cpu_threshold** and **scale_in_cpu_threshold**: CPU thresholds for scaling

### Key Outputs

- **load_balancer_public_ip**: Public IP address to access the application
- **load_balancer_url**: Complete URL to access the load-balanced web application
- **vmss_instances**: Number of VM instances currently in the scale set

## Common Issues and Solutions

1. **Load balancer health probes failing**: Ensure the web server is properly installed and configured
2. **Cannot access the application**: Check the NSG rules and health probe status
3. **Autoscaling not working**: Ensure CPU metrics are being collected and thresholds are appropriate
4. **Scale set deployment failing**: Check VM size availability in the selected region

## Advanced Customizations

For more complex deployments, consider:

1. Adding NAT rules for direct access to specific instances:
```terraform
resource "azurerm_lb_nat_rule" "ssh" {
  resource_group_name            = azurerm_resource_group.vmss_rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "ssh-rule"
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = var.lb_frontend_ip_name
}
```

2. Configuring multiple load balancing rules for different applications:
```terraform
resource "azurerm_lb_rule" "https_rule" {
  name                           = "https-rule"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = var.lb_frontend_ip_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.https_probe.id
}
```

3. Creating an internal load balancer for a multi-tier application:
```terraform
resource "azurerm_lb" "internal_lb" {
  name                = "internal-lb"
  location            = azurerm_resource_group.vmss_rg.location
  resource_group_name = azurerm_resource_group.vmss_rg.name
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

## Security Best Practices

1. **Restrict Public Access**: Limit inbound traffic to only necessary ports
2. **Use SSH Keys**: Use SSH key authentication instead of passwords
3. **Update Images Regularly**: Use recent VM images with the latest security patches
4. **Monitor Health and Performance**: Use health probes and Azure Monitor to track VM health
5. **Consider Auto-Healing**: Configure automatic instance replacement for unhealthy VMs 