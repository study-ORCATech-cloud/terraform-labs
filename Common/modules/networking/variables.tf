variable "provider_type" {
  description = "The cloud provider to use (aws, azure, or gcp)"
  type        = string
  default     = "aws"

  validation {
    condition     = contains(["aws", "azure", "gcp"], var.provider_type)
    error_message = "Valid values for provider_type are: aws, azure, gcp."
  }
}

variable "network_name" {
  description = "Name for the network resources"
  type        = string
  default     = "terraform-network"
}

variable "cidr_block" {
  description = "CIDR block for the network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "location" {
  description = "Region/location for the cloud resources"
  type        = string
  default     = "us-east-1"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group (only used for Azure)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 
