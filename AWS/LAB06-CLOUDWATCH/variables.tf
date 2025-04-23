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

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c1bc246476a5572b" # Amazon Linux 2 AMI in eu-west-1
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "web_access_log_group_name" {
  description = "Name for the web server access log group"
  type        = string
  default     = "/aws/ec2/web/access"
}

variable "web_error_log_group_name" {
  description = "Name for the web server error log group"
  type        = string
  default     = "/aws/ec2/web/error"
}

variable "system_log_group_name" {
  description = "Name for the system log group"
  type        = string
  default     = "/aws/ec2/system"
}

variable "alarm_email" {
  description = "Email address to send alarm notifications to"
  type        = string
  default     = null
} 
