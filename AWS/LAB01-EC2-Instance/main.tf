provider "aws" {
  region = var.aws_region

  # Optional: you can add profile and other provider settings here
  # profile = "default" 
}

# Create a security group in the default VPC
resource "aws_security_group" "lab01_sg" {
  name        = "lab01-security-group"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from anywhere (for demo purposes only)"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "lab01-sg"
    Environment = var.environment
    Lab         = "LAB01-EC2-Instance"
  }
}

# Create key pair for EC2 instance
resource "aws_key_pair" "lab01_key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Create EC2 instance
resource "aws_instance" "lab01_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.lab01_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.lab01_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to Terraform LAB01 - EC2 Instance</h1>" > /var/www/html/index.html
              echo "<p>This page was created by Terraform on $(date)</p>" >> /var/www/html/index.html
              EOF

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name        = "lab01-instance"
    Environment = var.environment
    Lab         = "LAB01-EC2-Instance"
  }
}
