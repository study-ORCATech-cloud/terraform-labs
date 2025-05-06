variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone to deploy resources"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "The name of the Compute Engine instance"
  type        = string
  default     = "terraform-instance"
}

variable "machine_type" {
  description = "The machine type for the Compute Engine instance"
  type        = string
  default     = "e2-medium"
}

variable "image" {
  description = "The boot disk image for the Compute Engine instance"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "network_tags" {
  description = "Network tags to apply to the instance"
  type        = list(string)
  default     = ["http-server"]
}

variable "labels" {
  description = "Labels to apply to the instance"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "ssh_username" {
  description = "Username for SSH access to the VM"
  type        = string
  default     = "vm_user"
}

variable "ssh_pub_key_path" {
  description = "Path to the public SSH key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the instance to update its properties"
  type        = bool
  default     = true
} 
