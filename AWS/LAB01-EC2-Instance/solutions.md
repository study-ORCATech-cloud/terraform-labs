# LAB01: EC2 Instance - Solutions

This document contains solutions to the TODOs in the main.tf and outputs.tf files for LAB01.

## Solutions for main.tf

### Solution: Security Group

```hcl
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
```

### Solution: Key Pair

```hcl
# Create key pair for EC2 instance
resource "aws_key_pair" "lab01_key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}
```

### Solution: AMI Data Resource

```hcl
data "aws_ami" "linux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

### Solution: EC2 Instance

```hcl
# Create EC2 instance
resource "aws_instance" "lab01_instance" {
  ami                    = data.aws_ami.linux2.id
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
```

## Solutions for outputs.tf

### Solution: Instance ID Output

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.lab01_instance.id
}
```

### Solution: Instance Public IP Output

```hcl
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.lab01_instance.public_ip
}
```

### Solution: Instance Public DNS Output

```hcl
output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.lab01_instance.public_dns
}
```

### Solution: Security Group ID Output

```hcl
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.lab01_sg.id
}
```

### Solution: SSH Command Output

```hcl
output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.lab01_instance.public_dns}"
}
```

## Explanation

### Security Group
- We define a security group to control inbound and outbound traffic.
- The SSH rule allows remote administration via port 22.
- The HTTP rule enables web server access via port 80.
- The egress rule allows all outbound communications.
- Tags help with resource identification and organization.

### Key Pair
- We create a key pair using the provided variable values.
- The `file()` function reads the public key from the specified path.

### EC2 Instance
- We create an EC2 instance with the specified AMI and instance type.
- The instance is associated with the key pair and security group created earlier.
- The user_data script runs at instance launch to:
  - Update the system
  - Install and configure Apache web server
  - Create a simple welcome page
- We configure an 8GB gp2 root volume.
- Tags are added for resource identification and management.

### Outputs
- We define outputs to expose important information about our resources.
- The instance_id output returns the unique identifier of the created EC2 instance.
- The public_ip and public_dns outputs provide access information for the instance.
- The security_group_id output is useful for references in other configurations.
- The ssh_command output generates a ready-to-use command for connecting to the instance.

## Testing
After implementing these solutions and running `terraform apply`, you should:
1. Be able to connect to the instance via SSH using the ssh_command output
2. See the welcome page when visiting the instance's public IP in a browser
3. Verify all resources have the proper tags 
