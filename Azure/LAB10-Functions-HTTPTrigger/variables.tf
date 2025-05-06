variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "functions-lab-rg"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Name of the storage account for function app (must be globally unique)"
  type        = string
  default     = "funclabtfstorage"
}

variable "service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "functions-lab-plan"
}

variable "function_app_name" {
  description = "Name of the Azure Function App (must be globally unique)"
  type        = string
  default     = "functions-lab-app"
}

variable "function_name" {
  description = "Name of the Function within the Function App"
  type        = string
  default     = "HttpTrigger"
}

variable "app_insights_name" {
  description = "Name of the Application Insights resource"
  type        = string
  default     = "functions-lab-insights"
}

variable "os_type" {
  description = "OS type for the Function App (Windows or Linux)"
  type        = string
  default     = "Linux"
  validation {
    condition     = contains(["Windows", "Linux"], var.os_type)
    error_message = "OS type must be either 'Windows' or 'Linux'."
  }
}

variable "function_runtime" {
  description = "Runtime stack for the Function App (node, python, dotnet, etc.)"
  type        = string
  default     = "python"
  validation {
    condition     = contains(["node", "python", "dotnet", "java", "powershell"], var.function_runtime)
    error_message = "Runtime must be one of: node, python, dotnet, java, powershell."
  }
}

variable "function_runtime_version" {
  description = "Version of the runtime to use (depends on function_runtime)"
  type        = string
  default     = "3.9"
}

variable "zip_deploy_file" {
  description = "Path to the zip file containing the function code"
  type        = string
  default     = "function.zip"
}

variable "auth_level" {
  description = "Authentication level for HTTP triggered functions (anonymous or function)"
  type        = string
  default     = "function"
  validation {
    condition     = contains(["anonymous", "function"], var.auth_level)
    error_message = "Authentication level must be either 'anonymous' or 'function'."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "lab"
    project     = "azure-functions"
    managed_by  = "terraform"
  }
} 
