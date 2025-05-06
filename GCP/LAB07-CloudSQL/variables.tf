variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the Cloud SQL instance"
  type        = string
  default     = "us-central1"
}

variable "instance_name" {
  description = "Name for the Cloud SQL instance"
  type        = string
  default     = "postgres-instance"
}

variable "db_name" {
  description = "Name for the PostgreSQL database"
  type        = string
  default     = "postgres_db"
}

variable "db_username" {
  description = "Username for database access"
  type        = string
  default     = "postgres_user"
}

variable "db_password" {
  description = "Password for database access (sensitive value)"
  type        = string
  sensitive   = true
}

variable "machine_tier" {
  description = "Machine tier for the Cloud SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "availability_type" {
  description = "Availability type for the Cloud SQL instance (REGIONAL or ZONAL)"
  type        = string
  default     = "ZONAL"
}

variable "enable_backups" {
  description = "Whether to enable automated backups"
  type        = bool
  default     = false
}

variable "backup_start_time" {
  description = "Start time for automated backups (HH:MM format in UTC)"
  type        = string
  default     = "02:00"
}

variable "backup_retention_days" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "enable_private_ip" {
  description = "Whether to use private IP for the instance"
  type        = bool
  default     = false
}

variable "network_id" {
  description = "VPC network ID for private IP configuration"
  type        = string
  default     = ""
}

variable "authorized_networks" {
  description = "List of authorized networks for public IP access"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "database_flags" {
  description = "Database flags for PostgreSQL configuration"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "max_connections"
      value = "100"
    },
    {
      name  = "shared_buffers"
      value = "128MB"
    }
  ]
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
