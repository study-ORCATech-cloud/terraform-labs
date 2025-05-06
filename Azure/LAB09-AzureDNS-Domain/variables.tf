variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "dns-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "domain_name" {
  description = "Domain name for the DNS zone (e.g., example.com)"
  type        = string
  default     = "example.com" # Students should change this to their actual domain
}

variable "zone_type" {
  description = "Type of DNS zone (Public or Private)"
  type        = string
  default     = "Public"
  validation {
    condition     = contains(["Public", "Private"], var.zone_type)
    error_message = "Zone type must be either 'Public' or 'Private'."
  }
}

variable "default_ttl" {
  description = "Default time-to-live value in seconds for DNS records"
  type        = number
  default     = 3600 # 1 hour
}

variable "a_records" {
  description = "List of A records to create"
  type = list(object({
    name    = string
    ttl     = optional(number)
    records = list(string) # List of IP addresses
  }))
  default = [
    {
      name    = "@" # Root domain
      records = ["1.2.3.4"]
    },
    {
      name    = "www" # www subdomain
      records = ["1.2.3.4"]
    },
    {
      name    = "app" # app subdomain
      ttl     = 300   # 5 minutes
      records = ["5.6.7.8"]
    }
  ]
}

variable "cname_records" {
  description = "List of CNAME records to create"
  type = list(object({
    name   = string
    ttl    = optional(number)
    record = string # Target FQDN
  }))
  default = [
    {
      name   = "blog"
      record = "blog-platform.example.com"
    },
    {
      name   = "mail"
      record = "mail-provider.example.com"
    }
  ]
}

variable "txt_records" {
  description = "List of TXT records to create"
  type = list(object({
    name    = string
    ttl     = optional(number)
    records = list(string) # List of text values
  }))
  default = [
    {
      name    = "@"
      records = ["v=spf1 include:_spf.example.com -all"]
    },
    {
      name    = "_dmarc"
      records = ["v=DMARC1; p=none; rua=mailto:dmarc@example.com"]
    }
  ]
}

variable "mx_records" {
  description = "List of MX records to create"
  type = list(object({
    name       = string
    ttl        = optional(number)
    preference = number
    exchange   = string
  }))
  default = [
    {
      name       = "@"
      preference = 10
      exchange   = "mail1.example.com"
    },
    {
      name       = "@"
      preference = 20
      exchange   = "mail2.example.com"
    }
  ]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "dns-domain"
    managed_by  = "terraform"
  }
} 
