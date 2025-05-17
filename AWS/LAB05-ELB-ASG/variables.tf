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
  default     = "lab05"
}

variable "vpc_id" {
  description = "ID of the VPC where resources will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ASG instances"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "scale_out_threshold" {
  description = "CPU utilization threshold for scaling out"
  type        = number
  default     = 70
}

variable "scale_in_threshold" {
  description = "CPU utilization threshold for scaling in"
  type        = number
  default     = 30
}

variable "evaluation_periods" {
  description = "Number of evaluation periods for CloudWatch alarms"
  type        = number
  default     = 2
}

variable "metric_period" {
  description = "Period in seconds for CloudWatch metrics evaluation"
  type        = number
  default     = 120
}
