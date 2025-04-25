# LAB05: Deploy a Load Balancer and Auto Scaling Group with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to build a highly available and scalable web application infrastructure on AWS. You'll configure an **Application Load Balancer (ALB)** to distribute traffic across an **Auto Scaling Group (ASG)** of EC2 instances. The load balancer will automatically route traffic to healthy instances across multiple availability zones, while the Auto Scaling Group will dynamically adjust capacity based on demand.

This lab demonstrates how infrastructure as code can be used to create resilient, self-healing application architectures that can automatically scale to handle fluctuating workloads.

---

## 🎯 Learning Objectives

- Create a launch template with properly configured user data for web servers
- Configure an Application Load Balancer with listeners and target groups
- Set up an Auto Scaling Group across multiple availability zones
- Implement scaling policies to respond to changes in demand
- Define CloudWatch alarms to trigger scaling actions based on metrics
- Configure security groups for load balancer and EC2 instance traffic
- Understand health checks and instance registration with target groups
- Test high availability and automatic scaling functionality

---

## 🧰 Prerequisites

- AWS account with administrator access
- Terraform v1.3+ installed
- AWS CLI installed and configured
- Existing VPC with public and private subnets (from LAB04 or use existing VPC)
- Basic understanding of load balancing and auto scaling concepts

---

## 📁 Files Structure

```
AWS/LAB05-ELB-ASG/
├── main.tf                  # Main configuration with TODO sections for students
├── variables.tf             # Variable declarations
├── outputs.tf               # Output definitions
├── terraform.tfvars         # Pre-defined input values (update with your VPC/subnet IDs)
├── solutions.md             # Solutions to the TODOs (for reference)
└── README.md                # Lab instructions
```

---

## 🌐 Architecture Overview

This lab implements a scalable web application architecture with the following components:

1. **Application Load Balancer**: Distributes incoming HTTP traffic to EC2 instances
2. **Target Group**: Registers instances and performs health checks
3. **Launch Template**: Defines instance configuration and bootstrap script
4. **Auto Scaling Group**: Manages instance lifecycle across availability zones
5. **Scaling Policies**: Adjust instance capacity based on metrics
6. **CloudWatch Alarms**: Monitor metrics and trigger scaling actions

The architecture follows AWS best practices by:
- Placing the Load Balancer in public subnets for internet access
- Deploying application instances in private subnets for security
- Distributing resources across multiple availability zones for high availability
- Using dynamic scaling to efficiently handle varying loads

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB05-ELB-ASG
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure Infrastructure Settings

1. Update the `terraform.tfvars` file with your VPC and subnet IDs:
   ```bash
   # Replace these values with your actual VPC and subnet IDs
   vpc_id             = "vpc-xxxxxxxxxxxxxxxxx"
   public_subnet_ids  = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
   private_subnet_ids = ["subnet-zzzzzzzz", "subnet-aaaaaaaa"]
   ```

   > ⚠️ **Important**: You can use outputs from LAB04-VPC or find the IDs in your AWS Console.

### Step 4: Complete the TODO Sections

The `main.tf` file contains several TODO sections that you need to implement:

1. **Security Groups**
   - Create security group for the ALB allowing HTTP traffic from anywhere
   - Create security group for EC2 instances allowing traffic only from the ALB

2. **Load Balancer and Target Group**
   - Configure an Application Load Balancer in public subnets
   - Set up a target group with appropriate health checks
   - Create an HTTP listener to forward traffic

3. **Launch Template**
   - Create a launch template with user data to install and configure Apache
   - Configure appropriate security group and network settings

4. **Auto Scaling Group**
   - Configure an ASG to span multiple availability zones
   - Set up desired capacity, minimum and maximum sizes
   - Attach to the target group for load balancing

5. **Scaling Policies and CloudWatch Alarms**
   - Set up scale-out and scale-in policies
   - Configure CloudWatch alarms to trigger scaling based on CPU utilization

Each TODO section includes specific requirements and hints to help you implement the solution.

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the resources to be created based on your implementation:
   - Security groups for ALB and EC2 instances
   - Application Load Balancer, target group, and listener
   - Launch template with user data
   - Auto Scaling Group configured across availability zones
   - Scaling policies and CloudWatch alarms

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm the deployment.

3. After successful application, Terraform will display outputs including:
   - Load balancer DNS name
   - Auto Scaling Group name
   - Security group IDs
   - Target group ARN

### Step 7: Test the Load Balancer and Auto Scaling

1. Access your application:
   - Open a web browser and navigate to the DNS name output of your load balancer
   - You should see a simple web page with hostname information

2. Test auto scaling:
   - Connect to one of your instances using SSH
   - Generate CPU load to trigger scale-out:
     ```bash
     # Install stress tool if not already installed
     sudo amazon-linux-extras install epel -y
     sudo yum install stress -y
     
     # Generate CPU load
     stress --cpu 2 --timeout 300
     ```
   - Observe new instances being launched in the Auto Scaling Group
   - After the stress test ends, wait for scale-in to occur

3. Verify load balancing:
   - Refresh your browser page multiple times
   - Observe that requests are distributed across different instances

---

## 🔍 Understanding the Components

### Security Groups

Security groups act as virtual firewalls for your instances and load balancers:
- The ALB security group allows HTTP (port 80) traffic from the internet
- The instance security group only allows traffic from the load balancer, providing an extra layer of security

### Load Balancer and Target Group

The Application Load Balancer:
- Sits in public subnets with internet connectivity
- Forwards HTTP requests to EC2 instances in private subnets
- Performs health checks to ensure traffic is only sent to healthy instances
- Automatically registers and deregisters instances from the target group

### Launch Template and Auto Scaling Group

The Launch Template:
- Defines the instance configuration including AMI, instance type, and security groups
- Contains user data script that provisions the web server software

The Auto Scaling Group:
- Spans multiple availability zones for high availability
- Automatically registers instances with the target group
- Maintains the desired number of instances
- Scales out or in based on demand

### Scaling Policies and Alarms

Scaling policies:
- Define what action to take when scaling is needed (add or remove instances)
- Are triggered by CloudWatch alarms that monitor metrics like CPU utilization
- Include cooldown periods to prevent rapid scaling fluctuations

---

## 🧼 Cleanup

When you're finished with the lab, you should destroy all created resources to avoid unexpected AWS charges.

```bash
terraform destroy
```

This will remove all resources created during this lab, including the load balancer, auto scaling group, and security groups.

---

## 💡 Extension Activities

- Add HTTPS support with an ACM certificate
- Implement a custom health check endpoint in your application
- Configure step scaling policies instead of simple scaling
- Add a target tracking scaling policy based on average request count
- Set up CloudWatch dashboards to monitor your application
- Implement session stickiness for the target group

---

## 📚 References

- [Application Load Balancer Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
- [Auto Scaling Groups Documentation](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html)
- [Launch Templates Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html)
- [CloudWatch Alarms Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## ✅ Key Takeaways

After completing this lab, you'll understand how to:

- Build a resilient, scalable architecture using AWS services
- Use Infrastructure as Code to define and deploy complex architectures
- Configure auto scaling based on demand metrics
- Set up proper load balancing for high availability
- Implement health checks and traffic distribution
- Apply security best practices with well-configured security groups