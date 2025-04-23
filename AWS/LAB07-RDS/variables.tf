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

variable "subnet_cidr_1" {
  description = "CIDR block for the first subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  description = "CIDR block for the second subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access the database"
  type        = string
  default     = "0.0.0.0/0" # This should be restricted in production
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "mysql-lab-instance"
}

variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
  default     = "labdb"
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  default     = "Password123!" # Change this in production
  sensitive   = true
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage for the RDS instance in GB"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Whether to deploy the RDS instance in multiple availability zones"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible"
  type        = bool
  default     = false
}

variable "create_client_instance" {
  description = "Whether to create an EC2 instance to serve as a MySQL client"
  type        = bool
  default     = true
}

variable "client_ami_id" {
  description = "AMI ID for the client EC2 instance"
  type        = string
  default     = "ami-0694d931cee996bbb" # Amazon Linux 2 AMI in eu-west-1
}

variable "key_name" {
  description = "Key pair name for SSH access to the client instance"
  type        = string
  default     = null
} 
