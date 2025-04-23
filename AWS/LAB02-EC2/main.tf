# AWS LAB01 - Basic Infrastructure

# Configure AWS provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
    Lab  = "AWS-LAB01"
  }
}

# Create a subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "public-subnet"
    Lab  = "AWS-LAB01"
  }
}

# Create a security group
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
    Lab  = "AWS-LAB01"
  }
}

resource "aws_instance" "ec2" {
  ami           = var.ec2-ami
  instance_type = var.ec2-instance-type

  vpc_security_group_ids = [aws_security_group.web.id]

  tags = {
    Name = var.ec2-name
  }
}

resource "null_resource" "run_script" {
  triggers = aws_instance.ec2

  provisioner "local-exec" {
    command = "echo 'EC2 has been created/updated successfully!'"
  }

  depends_on = [aws_instance.ec2]
}
