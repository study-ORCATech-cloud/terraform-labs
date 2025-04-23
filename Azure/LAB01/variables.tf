variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "example-resources"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
} 
