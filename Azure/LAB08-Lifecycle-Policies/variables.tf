variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "lifecycle-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique, lowercase, no hyphens)"
  type        = string
  default     = "lifecyclelab123" # Students should change this to a unique name
}

variable "replication_type" {
  description = "Type of replication for the storage account"
  type        = string
  default     = "LRS" # Locally redundant storage (cheapest option)
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "container_names" {
  description = "List of container names to create"
  type        = list(string)
  default     = ["documents", "backups", "logs"]
}

variable "enable_adls_gen2" {
  description = "Whether to enable hierarchical namespace (Azure Data Lake Storage Gen2)"
  type        = bool
  default     = false
}

variable "enable_immutability" {
  description = "Whether to enable immutability policies on any containers"
  type        = bool
  default     = false
}

variable "immutability_period" {
  description = "Number of days to retain immutable blobs (if enabled)"
  type        = number
  default     = 30
}

variable "immutable_container_name" {
  description = "Name of the container to apply immutability policy to (must be in container_names list)"
  type        = string
  default     = "backups"
}

variable "lifecycle_rules" {
  description = "List of lifecycle management rules"
  type = list(object({
    name    = string
    enabled = bool
    filters = object({
      prefix_match = list(string)
      blob_types   = list(string)
    })
    actions = object({
      tier_to_cool_after_days    = number
      tier_to_archive_after_days = number
      delete_after_days          = number
    })
  }))
  default = [
    {
      name    = "default-rule"
      enabled = true
      filters = {
        prefix_match = [""]
        blob_types   = ["blockBlob"]
      }
      actions = {
        tier_to_cool_after_days    = 30
        tier_to_archive_after_days = 90
        delete_after_days          = 365
      }
    },
    {
      name    = "logs-rule"
      enabled = true
      filters = {
        prefix_match = ["logs/"]
        blob_types   = ["blockBlob"]
      }
      actions = {
        tier_to_cool_after_days    = 7
        tier_to_archive_after_days = 30
        delete_after_days          = 90
      }
    }
  ]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "storage-lifecycle"
    managed_by  = "terraform"
  }
} 
