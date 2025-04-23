variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Environment name for tagging resources"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  default     = null # Must be provided in terraform.tfvars
}

variable "versioning_enabled" {
  description = "Whether to enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "allow_public_access" {
  description = "Whether to allow public access to the S3 bucket"
  type        = bool
  default     = false
}

variable "enable_static_website" {
  description = "Whether to enable static website hosting for the S3 bucket"
  type        = bool
  default     = false
}
