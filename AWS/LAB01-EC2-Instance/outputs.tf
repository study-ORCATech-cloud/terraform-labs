# TODO: Define an output for the instance_id
# Requirements:
# - Name it "instance_id"
# - Description should be "ID of the EC2 instance"
# - Value should be the ID of the EC2 instance you created
# HINT: Use aws_instance.lab01_instance.id

# TODO: Define an output for the instance_public_ip
# Requirements:
# - Name it "instance_public_ip"
# - Description should be "Public IP address of the EC2 instance"
# - Value should be the public IP of the EC2 instance
# HINT: Use aws_instance.lab01_instance.public_ip

# TODO: Define an output for the instance_public_dns
# Requirements:
# - Name it "instance_public_dns"
# - Description should be "Public DNS of the EC2 instance"
# - Value should be the public DNS of the EC2 instance
# HINT: Use aws_instance.lab01_instance.public_dns

# TODO: Define an output for the security_group_id
# Requirements:
# - Name it "security_group_id"
# - Description should be "ID of the security group"
# - Value should be the ID of the security group you created
# HINT: Use aws_security_group.lab01_sg.id

# TODO: Define an output for the ssh_command
# Requirements:
# - Name it "ssh_command"
# - Description should be "Command to SSH into the instance"
# - Value should be a command to SSH into the instance using the private key and public DNS
# HINT: Use string interpolation to build the command
