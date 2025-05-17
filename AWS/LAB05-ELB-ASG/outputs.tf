# TODO: Define an output for elb_dns_name
# Requirements:
# - Name it "elb_dns_name"
# - Description should be "DNS name of the load balancer"
# - Value should be the DNS name of the load balancer
# HINT: Use aws_lb.app_lb.dns_name

# TODO: Define an output for autoscaling_group_name
# Requirements:
# - Name it "autoscaling_group_name"
# - Description should be "Name of the Auto Scaling Group"
# - Value should be the name of the ASG
# HINT: Use aws_autoscaling_group.app_asg.name

# TODO: Define an output for instance_security_group_id
# Requirements:
# - Name it "instance_security_group_id"
# - Description should be "ID of the security group attached to the instances"
# - Value should be the ID of the instance security group
# HINT: Use aws_security_group.instance_sg.id

# TODO: Define an output for lb_security_group_id
# Requirements:
# - Name it "lb_security_group_id"
# - Description should be "ID of the security group attached to the load balancer"
# - Value should be the ID of the ALB security group
# HINT: Use aws_security_group.alb_sg.id

# TODO: Define an output for target_group_arn
# Requirements:
# - Name it "target_group_arn"
# - Description should be "ARN of the target group"
# - Value should be the ARN of the target group
# HINT: Use aws_lb_target_group.app_tg.arn

# TODO: Define an output for launch_template_id
# Requirements:
# - Name it "launch_template_id"
# - Description should be "ID of the launch template"
# - Value should be the ID of the launch template
# HINT: Use aws_launch_template.app_launch_template.id

# TODO: Define an output for scale_out_policy_arn
# Requirements:
# - Name it "scale_out_policy_arn"
# - Description should be "ARN of the scale out policy"
# - Value should be the ARN of the scale out policy
# HINT: Use aws_autoscaling_policy.scale_out.arn

# TODO: Define an output for scale_in_policy_arn
# Requirements:
# - Name it "scale_in_policy_arn"
# - Description should be "ARN of the scale in policy"
# - Value should be the ARN of the scale in policy
# HINT: Use aws_autoscaling_policy.scale_in.arn
