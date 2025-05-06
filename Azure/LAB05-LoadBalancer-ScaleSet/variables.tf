variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "lb-vmss-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "lb-vmss-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "lb-vmss-subnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "lb-vmss-nsg"
}

variable "lb_public_ip_name" {
  description = "Name of the public IP for the load balancer"
  type        = string
  default     = "lb-public-ip"
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "web-loadbalancer"
}

variable "lb_frontend_ip_name" {
  description = "Name of the frontend IP configuration"
  type        = string
  default     = "lb-frontend-ip"
}

variable "lb_backend_pool_name" {
  description = "Name of the backend address pool"
  type        = string
  default     = "lb-backend-pool"
}

variable "lb_probe_name" {
  description = "Name of the health probe"
  type        = string
  default     = "http-probe"
}

variable "lb_probe_protocol" {
  description = "Protocol for the health probe"
  type        = string
  default     = "Http"
}

variable "lb_probe_port" {
  description = "Port for the health probe"
  type        = number
  default     = 80
}

variable "lb_probe_interval" {
  description = "Interval in seconds between probes"
  type        = number
  default     = 15
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of failed probes before instance is considered unhealthy"
  type        = number
  default     = 2
}

variable "lb_rule_name" {
  description = "Name of the load balancing rule"
  type        = string
  default     = "http-rule"
}

variable "lb_rule_protocol" {
  description = "Protocol for the load balancing rule"
  type        = string
  default     = "Tcp"
}

variable "lb_rule_frontend_port" {
  description = "Frontend port for the load balancing rule"
  type        = number
  default     = 80
}

variable "lb_rule_backend_port" {
  description = "Backend port for the load balancing rule"
  type        = number
  default     = 80
}

variable "vmss_name" {
  description = "Name of the VM scale set"
  type        = string
  default     = "web-vmss"
}

variable "vmss_instances" {
  description = "Initial number of VM instances"
  type        = number
  default     = 2
}

variable "vmss_sku" {
  description = "SKU for VM instances"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for VM instances"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for admin user"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN example@example.com"
}

variable "os_disk_caching" {
  description = "Caching type for OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "source_image_publisher" {
  description = "Publisher of VM image"
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "Offer of VM image"
  type        = string
  default     = "UbuntuServer"
}

variable "source_image_sku" {
  description = "SKU of VM image"
  type        = string
  default     = "18.04-LTS"
}

variable "source_image_version" {
  description = "Version of VM image"
  type        = string
  default     = "latest"
}

variable "custom_data_script" {
  description = "Base64 encoded script to configure the VM instances"
  type        = string
  default     = <<-CUSTOM_DATA
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    echo "<h1>Welcome to Azure Load Balancer and VM Scale Set Lab</h1><p>Instance: $(hostname)</p>" > /var/www/html/index.html
    service nginx restart
  CUSTOM_DATA
}

variable "enable_autoscaling" {
  description = "Whether to enable autoscaling for the VM scale set"
  type        = bool
  default     = false
}

variable "autoscale_name" {
  description = "Name of the autoscale setting"
  type        = string
  default     = "vmss-autoscale"
}

variable "autoscale_min_instances" {
  description = "Minimum number of instances for autoscaling"
  type        = number
  default     = 1
}

variable "autoscale_max_instances" {
  description = "Maximum number of instances for autoscaling"
  type        = number
  default     = 5
}

variable "autoscale_default_instances" {
  description = "Default number of instances for autoscaling"
  type        = number
  default     = 2
}

variable "scale_out_cpu_threshold" {
  description = "CPU threshold for scaling out"
  type        = number
  default     = 75
}

variable "scale_in_cpu_threshold" {
  description = "CPU threshold for scaling in"
  type        = number
  default     = 25
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "lb-vmss-deployment"
    managed_by  = "terraform"
  }
} 
