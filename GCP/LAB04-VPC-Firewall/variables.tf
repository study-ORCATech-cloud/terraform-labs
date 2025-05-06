variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the VPC and subnet"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "Name for the VPC network"
  type        = string
  default     = "terraform-vpc"
}

variable "subnet_name" {
  description = "Name for the subnet within the VPC"
  type        = string
  default     = "terraform-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "allowed_ssh_ips" {
  description = "List of IP addresses allowed to connect via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Default allows any IP (not recommended for production)
}

variable "ssh_target_tags" {
  description = "Network tags for instances that should allow SSH access"
  type        = list(string)
  default     = ["ssh-allowed"]
}

variable "web_target_tags" {
  description = "Network tags for instances that should allow HTTP/HTTPS access"
  type        = list(string)
  default     = ["web-server"]
}

variable "enable_egress_rule" {
  description = "Whether to create an egress firewall rule"
  type        = bool
  default     = false
}

variable "allowed_egress_destinations" {
  description = "List of IP ranges allowed for egress traffic"
  type        = list(string)
  default = [
    "199.36.153.8/30", # Google API access
    "35.191.0.0/16",   # Google Services
    "130.211.0.0/22"   # Google Load Balancing
  ]
}

variable "labels" {
  description = "Labels to apply to the resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "terraform-labs"
  }
} 
