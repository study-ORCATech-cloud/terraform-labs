variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the provider configuration"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone for the managed instance group"
  type        = string
  default     = "us-central1-a"
}

variable "name_prefix" {
  description = "Prefix used for naming resources"
  type        = string
  default     = "tf-lb-mig"
}

variable "machine_type" {
  description = "Machine type for the instance template"
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "Image for the instance template boot disk"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "instance_count" {
  description = "Target number of instances in the managed instance group"
  type        = number
  default     = 2
}

variable "enable_autoscaling" {
  description = "Whether to enable autoscaling for the managed instance group"
  type        = bool
  default     = true
}

variable "min_replicas" {
  description = "Minimum number of instances with autoscaling enabled"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Maximum number of instances with autoscaling enabled"
  type        = number
  default     = 5
}

variable "cooldown_period" {
  description = "Cooldown period for autoscaling (in seconds)"
  type        = number
  default     = 60
}

variable "health_check_interval" {
  description = "Interval between health checks (in seconds)"
  type        = number
  default     = 5
}

variable "health_check_timeout" {
  description = "Timeout for health checks (in seconds)"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful checks to mark an instance as healthy"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed checks to mark an instance as unhealthy"
  type        = number
  default     = 2
}

variable "backend_timeout" {
  description = "Backend service timeout (in seconds)"
  type        = number
  default     = 30
}

variable "connection_draining_timeout" {
  description = "Connection draining timeout for the backend service (in seconds)"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Network tags to apply to instances"
  type        = list(string)
  default     = ["http-server", "ssh-allowed"]
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
