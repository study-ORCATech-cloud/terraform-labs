variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name for the Cloud Storage bucket to store function code (must be globally unique)"
  type        = string
}

variable "bucket_location" {
  description = "Location for the Cloud Storage bucket"
  type        = string
  default     = "US"
}

variable "function_name" {
  description = "Name for the Cloud Function"
  type        = string
  default     = "http-function"
}

variable "function_entry_point" {
  description = "Entry point for the Cloud Function (name of the function in the code)"
  type        = string
  default     = "hello_http"
}

variable "function_runtime" {
  description = "Runtime for the Cloud Function"
  type        = string
  default     = "python310"
  validation {
    condition     = contains(["nodejs10", "nodejs12", "nodejs14", "nodejs16", "python37", "python38", "python39", "python310", "go113", "go116", "java11", "java17", "ruby26", "ruby27", "php74", "php81"], var.function_runtime)
    error_message = "Runtime must be one of the supported Cloud Functions runtimes."
  }
}

variable "function_memory" {
  description = "Memory allocation for the Cloud Function (MB)"
  type        = number
  default     = 256
  validation {
    condition     = contains([128, 256, 512, 1024, 2048, 4096, 8192], var.function_memory)
    error_message = "Memory must be one of the supported values: 128, 256, 512, 1024, 2048, 4096, or 8192 MB."
  }
}

variable "function_timeout" {
  description = "Timeout for the Cloud Function (seconds)"
  type        = number
  default     = 60
  validation {
    condition     = var.function_timeout >= 1 && var.function_timeout <= 540
    error_message = "Timeout must be between 1 and 540 seconds."
  }
}

variable "function_min_instances" {
  description = "Minimum number of instances for the Cloud Function"
  type        = number
  default     = 0
}

variable "function_max_instances" {
  description = "Maximum number of instances for the Cloud Function"
  type        = number
  default     = 1
}

variable "function_environment_variables" {
  description = "Environment variables for the Cloud Function"
  type        = map(string)
  default     = {}
}

variable "function_service_account_email" {
  description = "Service account email for the Cloud Function"
  type        = string
  default     = ""
}

variable "allow_unauthenticated" {
  description = "Whether to allow unauthenticated access to the function"
  type        = bool
  default     = true
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
