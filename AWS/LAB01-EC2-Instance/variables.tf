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

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Amazon Linux 2)"
  type        = string
  default     = "ami-0fee4a8e734946f11" # Amazon Linux 2 in eu-west-1
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
  default     = "lab01-key-pair"
}

variable "public_key_path" {
  description = "Path to the public key file for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
