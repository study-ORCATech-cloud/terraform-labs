# LAB05: ELB and ASG - Solutions

This document contains solutions to the TODOs in the main.tf file for LAB05.

## Solutions for Security Groups

```hcl
# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name        = "${var.name_prefix}-alb-sg"
    Environment = var.environment
    Lab         = "LAB05-ELB-ASG"
    Terraform   = "true"
  }
}

# Security Group for the EC2 instances
resource "aws_security_group" "instance_sg" {
  name        = "${var.name_prefix}-instance-sg"
  description = "Security group for the EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-instance-sg"
    Environment = var.environment
    Lab         = "LAB05-ELB-ASG"
    Terraform   = "true"
  }
}
```

## Solutions for Application Load Balancer and Target Group

```hcl
# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name_prefix}-alb"
    Environment = var.environment
    Lab         = "LAB05-ELB-ASG"
    Terraform   = "true"
  }
}

# Target Group for the ALB
resource "aws_lb_target_group" "app_tg" {
  name     = "${var.name_prefix}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name        = "${var.name_prefix}-tg"
    Environment = var.environment
    Lab         = "LAB05-ELB-ASG"
    Terraform   = "true"
  }
}

# ALB Listener
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```

## Solutions for Launch Template and Auto Scaling Group

```hcl
# Launch Template for ASG
resource "aws_launch_template" "app_launch_template" {
  name_prefix   = "${var.name_prefix}-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html><body><h1>Hello from $(hostname -f)</h1><p>LAB05: ELB-ASG Demo</p></body></html>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.name_prefix}-instance"
      Environment = var.environment
      Lab         = "LAB05-ELB-ASG"
      Terraform   = "true"
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.name_prefix}-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-instance"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Lab"
    value               = "LAB05-ELB-ASG"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}
```

## Solutions for Scaling Policies and CloudWatch Alarms

```hcl
# Scale Out Policy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.name_prefix}-scale-out-policy"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

# Scale In Policy
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.name_prefix}-scale-in-policy"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# High CPU Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.name_prefix}-high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.metric_period
  statistic           = "Average"
  threshold           = var.scale_out_threshold
  alarm_description   = "Scale out when CPU exceeds ${var.scale_out_threshold}%"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}

# Low CPU Alarm
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "${var.name_prefix}-low-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.metric_period
  statistic           = "Average"
  threshold           = var.scale_in_threshold
  alarm_description   = "Scale in when CPU is below ${var.scale_in_threshold}%"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
}
```

These solutions implement all the TODO items in the main.tf file according to the specified requirements. 