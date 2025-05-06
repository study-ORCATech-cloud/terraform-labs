variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "sql-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "sql_server_name" {
  description = "Name of the Azure SQL Server (must be globally unique)"
  type        = string
  default     = "sql-lab-server-123" # Students should change this to a unique name
}

variable "admin_username" {
  description = "Admin username for SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "admin_password" {
  description = "Admin password for SQL Server (must meet complexity requirements)"
  type        = string
  default     = "P@ssw0rd1234!"
  sensitive   = true
}

variable "database_name" {
  description = "Name of the SQL Database"
  type        = string
  default     = "sql-lab-db"
}

variable "database_sku" {
  description = "SKU name for the SQL Database (e.g., Basic, S0, P1, GP_S_Gen5_1)"
  type        = string
  default     = "Basic" # Basic tier for lab purposes
}

variable "database_collation" {
  description = "Collation for the SQL Database"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "max_size_gb" {
  description = "Maximum size of the database in gigabytes"
  type        = number
  default     = 2 # 2GB is the minimum for Basic tier
}

variable "allowed_ip_addresses" {
  description = "List of IP addresses allowed to access the SQL Server"
  type        = list(string)
  default     = [] # Empty by default, students would add their own IPs
  # Example: ["123.123.123.123", "124.124.124.124"]
}

variable "enable_azure_services" {
  description = "Whether to allow Azure services to access the SQL Server"
  type        = bool
  default     = true
}

variable "auto_pause_delay" {
  description = "Time in minutes after which database is automatically paused (only for serverless SKUs)"
  type        = number
  default     = 60 # 60 minutes
}

variable "enable_auditing" {
  description = "Whether to enable database auditing"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Number of days to retain audit logs"
  type        = number
  default     = 7
}

variable "enable_encryption" {
  description = "Whether to enable Transparent Data Encryption"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "azure-sql-database"
    managed_by  = "terraform"
  }
} 
