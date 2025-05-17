# TODO: Define an output for rds_endpoint
# Requirements:
# - Name it "rds_endpoint"
# - Description should be "The connection endpoint for the RDS instance"
# - Value should be the endpoint of the RDS instance you created
# HINT: Use aws_db_instance.mysql_db.endpoint

# TODO: Define an output for rds_port
# Requirements:
# - Name it "rds_port"
# - Description should be "The port on which the RDS instance accepts connections"
# - Value should be the port of the RDS instance
# HINT: Use aws_db_instance.mysql_db.port

# TODO: Define an output for rds_username
# Requirements:
# - Name it "rds_username"
# - Description should be "The master username for the RDS instance"
# - Value should be the username of the RDS instance
# - Set sensitive to true
# HINT: Use aws_db_instance.mysql_db.username

# TODO: Define an output for rds_database_name
# Requirements:
# - Name it "rds_database_name"
# - Description should be "The name of the initial database"
# - Value should be the name of the database
# HINT: Use aws_db_instance.mysql_db.db_name

# TODO: Define an output for rds_vpc_id
# Requirements:
# - Name it "rds_vpc_id"
# - Description should be "ID of the VPC in which the RDS instance is deployed"
# - Value should be the ID of the VPC you created
# HINT: Use aws_vpc.rds_vpc.id

# TODO: Define an output for rds_subnet_group_name
# Requirements:
# - Name it "rds_subnet_group_name"
# - Description should be "Name of the DB subnet group"
# - Value should be the name of the DB subnet group
# HINT: Use aws_db_subnet_group.rds_subnet_group.name

# TODO: Define an output for rds_security_group_id
# Requirements:
# - Name it "rds_security_group_id"
# - Description should be "ID of the security group attached to the RDS instance"
# - Value should be the ID of the security group
# HINT: Use aws_security_group.rds_sg.id

# TODO: Define an output for rds_parameter_group_name
# Requirements:
# - Name it "rds_parameter_group_name"
# - Description should be "Name of the DB parameter group"
# - Value should be the name of the parameter group
# HINT: Use aws_db_parameter_group.rds_param_group.name

# TODO: Define a conditional output for client_instance_public_ip
# Requirements:
# - Name it "client_instance_public_ip"
# - Description should be "Public IP address of the client EC2 instance"
# - Value should be the public IP if instance is created, otherwise null
# HINT: Use var.create_client_instance ? aws_instance.mysql_client[0].public_ip : null

# TODO: Define a conditional output for client_instance_id
# Requirements:
# - Name it "client_instance_id"
# - Description should be "ID of the client EC2 instance"
# - Value should be the instance ID if created, otherwise null
# HINT: Use var.create_client_instance ? aws_instance.mysql_client[0].id : null

# TODO: Define an output for connection_string
# Requirements:
# - Name it "connection_string"
# - Description should be "MySQL connection string"
# - Value should combine the RDS address, port, username, password, and database name
# - Set sensitive to true due to credentials
# HINT: Use "mysql -h ${aws_db_instance.mysql_db.address} -P ${aws_db_instance.mysql_db.port} -u ${var.db_username} -p${var.db_password} ${var.db_name}"
