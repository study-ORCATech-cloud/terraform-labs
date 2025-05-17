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

variable "name_prefix" {
  description = "Prefix to be used for resource names"
  type        = string
  default     = "lab08"
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
  default     = "terraform-s3-lifecycle-demo-bucket" # Make sure to change this
}

variable "standard_prefix" {
  description = "Prefix for standard tier objects"
  type        = string
  default     = "standard"
}

variable "logs_prefix" {
  description = "Prefix for log objects"
  type        = string
  default     = "logs"
}

variable "archive_prefix" {
  description = "Prefix for archive objects"
  type        = string
  default     = "archive"
}

variable "days_to_standard_ia" {
  description = "Number of days until objects transition to STANDARD_IA storage"
  type        = number
  default     = 30
}

variable "days_to_glacier" {
  description = "Number of days until objects transition to GLACIER storage"
  type        = number
  default     = 60
}

variable "days_to_expiration" {
  description = "Number of days until objects are deleted"
  type        = number
  default     = 365
}

variable "days_to_delete_noncurrent" {
  description = "Number of days until noncurrent versions are deleted"
  type        = number
  default     = 90
}

variable "storage_threshold" {
  description = "Threshold in bytes for S3 storage to trigger CloudWatch alarm"
  type        = number
  default     = 5000000000 # 5GB
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Lab"
    Project     = "Terraform-Labs"
    ManagedBy   = "Terraform"
  }
}
