# TODO: Create a security group in the default VPC
# Requirements:
# - Name it "lab01-security-group" with description "Allow SSH and HTTP"
# - Allow inbound SSH (port 22) from anywhere
# - Allow inbound HTTP (port 80) from anywhere
# - Allow all outbound traffic
# - Add tags: Name="lab01-sg", Environment=var.environment, Lab="LAB01-EC2-Instance"
# HINT: Use the aws_security_group resource


# TODO: Create key pair for EC2 instance
# Requirements:
# - Use the key_name from variables
# - Use the public_key_path from variables to upload your public key
# HINT: Use the aws_key_pair resource

# TODO: Create Data Resource for fetching AMI ID
# Requirements:
# - Use `most_recent`
# - Filter by `name` of image `amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2`
# - Filter by `virtualization-type` of image `hvm`
# HINT: Use the aws_key_pair resource

# TODO: Create an EC2 instance
# Requirements:
# - Use the AMI ID from Data Resource
# - Use the instance type from variables
# - Use the key pair you created above
# - Use the security group you created above
# - Add a user_data script that:
#   * Updates the system
#   * Installs and starts Apache (httpd)
#   * Creates a simple welcome page
# - Configure a root volume of 8GB using gp2 volume type
# - Add tags: Name="lab01-instance", Environment=var.environment, Lab="LAB01-EC2-Instance"
# HINT: Use the aws_instance resource
