variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "example-lambda-function"
}

variable "lambda_memory_size" {
  description = "Memory size for the Lambda function in MB"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "Timeout for the Lambda function in seconds"
  type        = number
  default     = 30
}

variable "lambda_environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default = {
    environment = "dev"
  }
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "example-api-gateway"
}

variable "api_gateway_stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "dev"
}

variable "api_throttling_burst_limit" {
  description = "API Gateway throttling burst limit"
  type        = number
  default     = 5
}

variable "api_throttling_rate_limit" {
  description = "API Gateway throttling rate limit"
  type        = number
  default     = 10
}

variable "cors_allow_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "List of allowed HTTP methods for CORS"
  type        = list(string)
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allow_headers" {
  description = "List of allowed headers for CORS"
  type        = list(string)
  default     = ["Content-Type", "Authorization"]
}

variable "cors_max_age" {
  description = "Maximum age (in seconds) of the CORS configuration for caching"
  type        = number
  default     = 300
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function"
  type        = string
  default     = "python3.9"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "lambda-example"
    Terraform   = "true"
  }
}
