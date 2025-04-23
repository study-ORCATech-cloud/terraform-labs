variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ec2-ami" {
  type        = string
  description = "EC2 AMI"

  validation {
    condition     = startswith(var.ec2-ami, "ami-")
    error_message = "Variable 'ec2-ami' must start with 'ami-'."
  }
}

variable "ec2-instance-type" {
  type        = string
  description = "EC2 Instance Type, currently only allowed 'micro' machines"

  validation {
    condition     = endswith(var.ec2-instance-type, "micro")
    error_message = "Variable 'ec2-instance-type' must end with '.micro'."
  }
}

variable "ec2-name" {
  type        = string
  description = "EC2 Instance Name"
  default     = "my-new-machine"
}
