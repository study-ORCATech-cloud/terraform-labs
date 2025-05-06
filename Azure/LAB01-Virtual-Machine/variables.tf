variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "vm-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vm-lab-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "vm-lab-subnet"
}

variable "subnet_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_ip_name" {
  description = "Name of the public IP address"
  type        = string
  default     = "vm-lab-pip"
}

variable "nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "vm-lab-nic"
}

variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
  default     = "vm-lab-nsg"
}

variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
  default     = "vm-lab"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Username for the VM admin account"
  type        = string
  default     = "azureuser"
}

variable "os_disk_name" {
  description = "Name of the OS disk"
  type        = string
  default     = "vm-lab-osdisk"
}

variable "os_disk_caching" {
  description = "Caching option for the OS disk"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "source_image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "source_image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "UbuntuServer"
}

variable "source_image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "18.04-LTS"
}

variable "source_image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

variable "generate_ssh_key" {
  description = "Whether to generate a new SSH key"
  type        = bool
  default     = true
}

variable "ssh_public_key_path" {
  description = "Path to an existing SSH public key (if not generating a new one)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "vm-deployment"
    managed_by  = "terraform"
  }
} 
