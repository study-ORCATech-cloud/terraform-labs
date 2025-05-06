variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "monitoring-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "monitoring-lab-workspace"
}

variable "retention_days" {
  description = "Number of days to retain data in Log Analytics"
  type        = number
  default     = 30
}

variable "create_test_vm" {
  description = "Flag to determine if a test VM should be created"
  type        = bool
  default     = true
}

variable "vm_name" {
  description = "Name of the test virtual machine"
  type        = string
  default     = "monitoring-test-vm"
}

variable "vm_size" {
  description = "Size of the test virtual machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for test VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for test VM"
  type        = string
  default     = "P@ssw0rd1234!"
  sensitive   = true
}

variable "alert_name" {
  description = "Name of the metric alert"
  type        = string
  default     = "high-cpu-alert"
}

variable "cpu_threshold" {
  description = "CPU threshold percentage for alerting"
  type        = number
  default     = 80
}

variable "alert_severity" {
  description = "Severity level for alerts (0-4, with 0 being most severe)"
  type        = number
  default     = 2
}

variable "action_group_name" {
  description = "Name of the action group for alert notifications"
  type        = string
  default     = "monitoring-lab-action-group"
}

variable "alert_email" {
  description = "Email address to receive alert notifications"
  type        = string
  default     = "admin@example.com"
}

variable "query_name" {
  description = "Name of the Log Analytics saved query"
  type        = string
  default     = "high-cpu-events"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "azure-monitoring"
    managed_by  = "terraform"
  }
} 
