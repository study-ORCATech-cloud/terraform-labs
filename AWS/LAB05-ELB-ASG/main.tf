# ---------------------------------------
# Security Groups
# ---------------------------------------

# TODO: Create a security group for the Application Load Balancer
# Requirements:
# - Name it "${var.name_prefix}-alb-sg"
# - Allow HTTP traffic (port 80) from anywhere (0.0.0.0/0)
# - Allow all outbound traffic
# - Add tags: Name, Environment, Lab="LAB05-ELB-ASG", Terraform="true"
# HINT: Use the aws_security_group resource with the vpc_id from variables

# TODO: Create a security group for the EC2 instances in the Auto Scaling Group
# Requirements:
# - Name it "${var.name_prefix}-instance-sg"
# - Allow HTTP traffic (port 80) ONLY from the ALB security group
# - Allow all outbound traffic
# - Add tags: Name, Environment, Lab="LAB05-ELB-ASG", Terraform="true"
# HINT: Use security_groups = [aws_security_group.alb_sg.id] in the ingress block

# ---------------------------------------
# Application Load Balancer
# ---------------------------------------

# TODO: Create an Application Load Balancer
# Requirements:
# - Name it "${var.name_prefix}-alb"
# - Make it internet-facing (internal = false)
# - Use the ALB security group created above
# - Deploy across public subnets provided in var.public_subnet_ids
# - Disable deletion protection for this lab
# - Add tags: Name, Environment, Lab="LAB05-ELB-ASG", Terraform="true"
# HINT: Use the aws_lb resource with load_balancer_type = "application"

# TODO: Create a Target Group for the ALB
# Requirements:
# - Name it "${var.name_prefix}-tg"
# - Configure it for HTTP traffic on port 80
# - Use the VPC ID from variables
# - Configure a health check that:
#   - Checks the "/" path
#   - Uses port "traffic-port"
#   - Has a healthy threshold of 2
#   - Has an unhealthy threshold of 2
#   - Uses a timeout of 5 seconds
#   - Uses a 30-second interval
#   - Expects a 200 status code
# - Add tags: Name, Environment, Lab="LAB05-ELB-ASG", Terraform="true"
# HINT: Use the aws_lb_target_group resource with the health_check block

# TODO: Create an ALB Listener
# Requirements:
# - Listen on port 80 for HTTP traffic
# - Forward traffic to the target group created above
# - Use the ALB ARN for the load_balancer_arn attribute
# HINT: Use the aws_lb_listener resource with a forward action

# ---------------------------------------
# Launch Template and Auto Scaling Group
# ---------------------------------------

# TODO: Create a Launch Template for the Auto Scaling Group
# Requirements:
# - Name it with prefix "${var.name_prefix}-launch-template"
# - Use the AMI ID from variables
# - Use the instance type from variables
# - Use the key name from variables if provided
# - Configure network interfaces with:
#   - Security group from the instance security group created above
#   - Public IP association
# - Add user data script that:
#   - Updates the system
#   - Installs and starts Apache httpd
#   - Creates a simple HTML page showing the hostname and lab info
# - Add instance tags with Name = "${var.name_prefix}-instance", Environment, Lab="LAB05-ELB-ASG", Terraform="true"
# HINT: Use the aws_launch_template resource with base64encode for user_data

# TODO: Create an Auto Scaling Group
# Requirements:
# - Name it "${var.name_prefix}-asg"
# - Set min_size, max_size, and desired_capacity from variables
# - Deploy across private subnets provided in var.private_subnet_ids
# - Use the launch template created above
# - Connect to the target group created above
# - Use ELB health check type with 300-second grace period
# - Add tags that propagate to instances: Name = "${var.name_prefix}-instance", Environment, Lab="LAB05-ELB-ASG"
# HINT: Use the aws_autoscaling_group resource with tag blocks that have propagate_at_launch = true

# ---------------------------------------
# Scaling Policies and CloudWatch Alarms
# ---------------------------------------

# TODO: Create Scale Out Policy
# Requirements:
# - Name it "${var.name_prefix}-scale-out-policy"
# - Increase capacity by 1 instance
# - Set a 300-second cooldown period
# HINT: Use the aws_autoscaling_policy resource with scaling_adjustment = 1

# TODO: Create Scale In Policy
# Requirements:
# - Name it "${var.name_prefix}-scale-in-policy"
# - Decrease capacity by 1 instance
# - Set a 300-second cooldown period
# HINT: Use the aws_autoscaling_policy resource with scaling_adjustment = -1

# TODO: Create a High CPU Alarm
# Requirements:
# - Name it "${var.name_prefix}-high-cpu-alarm"
# - Trigger when average CPU utilization is >= var.scale_out_threshold for var.evaluation_periods consecutive periods of var.metric_period seconds
# - Add description: "Scale out when CPU exceeds ${var.scale_out_threshold}%"
# - Configure the alarm to trigger the scale-out policy
# - Use the Auto Scaling Group name in the dimensions
# HINT: Use the aws_cloudwatch_metric_alarm resource with metric_name = "CPUUtilization"

# TODO: Create a Low CPU Alarm
# Requirements:
# - Name it "${var.name_prefix}-low-cpu-alarm"
# - Trigger when average CPU utilization is <= var.scale_in_threshold for var.evaluation_periods consecutive periods of var.metric_period seconds
# - Add description: "Scale in when CPU is below ${var.scale_in_threshold}%"
# - Configure the alarm to trigger the scale-in policy
# - Use the Auto Scaling Group name in the dimensions
# HINT: Use the aws_cloudwatch_metric_alarm resource with comparison_operator = "LessThanOrEqualToThreshold"
