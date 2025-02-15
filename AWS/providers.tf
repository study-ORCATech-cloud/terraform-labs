provider "aws" {
  region = var.region
}

variable "region" {
  default = "eu-west-1"
}
