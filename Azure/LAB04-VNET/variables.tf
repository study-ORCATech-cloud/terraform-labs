variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "vnet-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "main-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "Custom DNS servers for the virtual network (optional)"
  type        = list(string)
  default     = []
}

variable "subnet_config" {
  description = "Configuration for subnets to be created within the virtual network"
  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
  default = {
    web = {
      name              = "web-subnet"
      address_prefixes  = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Web"]
    },
    app = {
      name              = "app-subnet"
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = []
    },
    db = {
      name              = "db-subnet"
      address_prefixes  = ["10.0.3.0/24"]
      service_endpoints = ["Microsoft.Sql"]
    }
  }
}

variable "nsg_config" {
  description = "Configuration for network security groups"
  type = map(object({
    name = string
  }))
  default = {
    web = {
      name = "web-nsg"
    },
    app = {
      name = "app-nsg"
    },
    db = {
      name = "db-nsg"
    }
  }
}

variable "nsg_rules" {
  description = "Security rules for network security groups"
  type = map(object({
    name                       = string
    nsg_key                    = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
    description                = string
  }))
  default = {
    allow_http = {
      name                       = "allow-http"
      nsg_key                    = "web"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow HTTP traffic to web subnet"
    },
    allow_https = {
      name                       = "allow-https"
      nsg_key                    = "web"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow HTTPS traffic to web subnet"
    },
    allow_app = {
      name                       = "allow-app"
      nsg_key                    = "app"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "10.0.1.0/24"
      destination_address_prefix = "*"
      description                = "Allow application traffic from web subnet"
    },
    allow_db = {
      name                       = "allow-db"
      nsg_key                    = "db"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "10.0.2.0/24"
      destination_address_prefix = "*"
      description                = "Allow database traffic from application subnet"
    }
  }
}

variable "nsg_subnet_associations" {
  description = "Map of NSGs to be associated with specific subnets"
  type = map(object({
    subnet_key = string
    nsg_key    = string
  }))
  default = {
    web = {
      subnet_key = "web"
      nsg_key    = "web"
    },
    app = {
      subnet_key = "app"
      nsg_key    = "app"
    },
    db = {
      subnet_key = "db"
      nsg_key    = "db"
    }
  }
}

variable "enable_vnet_peering" {
  description = "Whether to enable VNet peering"
  type        = bool
  default     = false
}

variable "peer_vnet_name" {
  description = "Name of the peer virtual network"
  type        = string
  default     = "peer-vnet"
}

variable "peer_vnet_address_space" {
  description = "Address space for the peer virtual network"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "vnet-deployment"
    managed_by  = "terraform"
  }
} 
