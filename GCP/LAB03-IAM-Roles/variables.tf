variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the provider configuration"
  type        = string
  default     = "us-central1"
}

variable "custom_role_id" {
  description = "ID for the custom IAM role (must be unique within project)"
  type        = string
  default     = "terraformCustomRole"
}

variable "custom_role_permissions" {
  description = "List of permissions to include in the custom role"
  type        = list(string)
  default = [
    "storage.buckets.get",
    "storage.objects.get",
    "storage.objects.list",
    "monitoring.timeSeries.list",
    "logging.logEntries.list"
  ]
}

variable "service_account_name" {
  description = "Name for the service account (must be unique within project)"
  type        = string
  default     = "terraform-sa"
}

variable "enable_conditional_binding" {
  description = "Whether to create a conditional IAM binding"
  type        = bool
  default     = false
}

variable "conditional_title" {
  description = "Title for the conditional binding"
  type        = string
  default     = "expires_after_2023"
}

variable "conditional_description" {
  description = "Description for the conditional binding"
  type        = string
  default     = "Expires after 2023"
}

variable "conditional_expression" {
  description = "Expression for the conditional binding"
  type        = string
  default     = "request.time < timestamp(\"2024-01-01T00:00:00Z\")"
} 
