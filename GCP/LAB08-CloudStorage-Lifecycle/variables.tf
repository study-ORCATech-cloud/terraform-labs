variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "primary_bucket_name" {
  description = "Name for the primary Cloud Storage bucket (must be globally unique)"
  type        = string
}

variable "secondary_bucket_name" {
  description = "Name for the secondary Cloud Storage bucket with versioning (must be globally unique)"
  type        = string
}

variable "bucket_location" {
  description = "Location for Cloud Storage buckets (regional or multi-regional)"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "Storage class for the primary bucket"
  type        = string
  default     = "STANDARD"
  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "transition_storage_class" {
  description = "Storage class to transition objects to after transition_age_in_days"
  type        = string
  default     = "NEARLINE"
  validation {
    condition     = contains(["NEARLINE", "COLDLINE", "ARCHIVE"], var.transition_storage_class)
    error_message = "Transition storage class must be one of: NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "age_in_days" {
  description = "Age in days after which objects should be deleted"
  type        = number
  default     = 90
}

variable "transition_age_in_days" {
  description = "Age in days after which objects should transition to a different storage class"
  type        = number
  default     = 30
}

variable "noncurrent_age_in_days" {
  description = "Age in days after which non-current object versions should be deleted"
  type        = number
  default     = 30
}

variable "num_versions_to_keep" {
  description = "Number of newer versions to keep per object"
  type        = number
  default     = 3
}

variable "apply_prefix_filter" {
  description = "Whether to apply prefix-based filters to lifecycle rules"
  type        = bool
  default     = false
}

variable "prefix_filters" {
  description = "Map of prefix names to their filter values and ages for deletion"
  type = map(object({
    prefix     = string
    age_in_days = number
  }))
  default = {
    logs = {
      prefix     = "logs/"
      age_in_days = 14
    },
    tmp = {
      prefix     = "tmp/"
      age_in_days = 1
    }
  }
}

variable "create_prefix_bucket" {
  description = "Whether to create a separate bucket with prefix-based rules"
  type        = bool
  default     = false
}

variable "prefix_bucket_name" {
  description = "Name for the bucket with prefix-based rules (must be globally unique)"
  type        = string
  default     = ""
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "terraform-labs"
  }
} 