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
