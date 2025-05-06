variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the provider configuration"
  type        = string
  default     = "us-central1"
}

variable "dashboard_name" {
  description = "Name for the monitoring dashboard"
  type        = string
  default     = "terraform-monitoring-dashboard"
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization alert (0.0-1.0)"
  type        = number
  default     = 0.8 # 80% utilization
}

variable "network_threshold" {
  description = "Threshold for network egress alert in bytes"
  type        = number
  default     = 10000000 # 10MB
}

variable "alert_duration" {
  description = "Duration to wait before triggering an alert (in seconds)"
  type        = string
  default     = "60s"
}

variable "alert_documentation" {
  description = "Documentation message to include with the alert"
  type        = string
  default     = "High resource utilization detected. Please check the VM and consider scaling if this is expected behavior."
}

variable "notification_channels" {
  description = "List of notification channel IDs for alerts"
  type        = list(string)
  default     = []
}

variable "monitored_resource_types" {
  description = "List of resource types to monitor"
  type        = list(string)
  default     = ["gce_instance"]
}

variable "create_logs_bucket" {
  description = "Whether to create a storage bucket for logs"
  type        = bool
  default     = false
}

variable "logs_bucket_name" {
  description = "Name for the logs storage bucket (must be globally unique)"
  type        = string
  default     = ""
}

variable "logs_storage_class" {
  description = "Storage class for the logs bucket"
  type        = string
  default     = "STANDARD"
}

variable "logs_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "create_logs_bigquery" {
  description = "Whether to create a BigQuery dataset for logs"
  type        = bool
  default     = false
}

variable "logs_dataset_id" {
  description = "BigQuery dataset ID for logs"
  type        = string
  default     = "logs_dataset"
}

variable "logs_table_id" {
  description = "BigQuery table ID for logs"
  type        = string
  default     = "instance_logs"
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
