variable "credentials_file" {
  description = "Path to the GCP credentials JSON file"
  type        = string
  default     = "credentials.json"
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "example-project"
}

variable "region" {
  description = "GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone to deploy resources"
  type        = string
  default     = "us-central1-a"
} 
