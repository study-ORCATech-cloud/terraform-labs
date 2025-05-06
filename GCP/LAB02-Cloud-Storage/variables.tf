variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the provider configuration"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the Cloud Storage bucket (must be globally unique)"
  type        = string
}

variable "location" {
  description = "The location for the Cloud Storage bucket (regional or multi-regional)"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The storage class for the bucket (STANDARD, NEARLINE, COLDLINE, or ARCHIVE)"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, or ARCHIVE."
  }
}

variable "enable_versioning" {
  description = "Whether to enable object versioning for the bucket"
  type        = bool
  default     = false
}

variable "enable_website" {
  description = "Whether to enable static website hosting for the bucket"
  type        = bool
  default     = false
}

variable "enable_lifecycle_rules" {
  description = "Whether to enable lifecycle rules for the bucket"
  type        = bool
  default     = false
}

variable "lifecycle_age_days" {
  description = "The number of days after which objects should be deleted by lifecycle rules"
  type        = number
  default     = 30
}

variable "labels" {
  description = "Labels to apply to the bucket"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "terraform-labs"
  }
} 
