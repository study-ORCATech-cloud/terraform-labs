# LAB06: Advanced AWS CloudWatch Monitoring and Alerting with Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Terraform** to deploy a complete CloudWatch monitoring solution. You'll set up an EC2 instance with the CloudWatch agent, create log groups, configure metric filters, set up alarms, and build a custom dashboard to visualize all your monitoring data.

This hands-on lab will guide you through the process of implementing a proper monitoring and alerting infrastructure using Infrastructure as Code (IaC) principles.

---

## 🎯 Learning Objectives

- Deploy infrastructure with built-in monitoring capabilities
- Configure the CloudWatch agent for custom metrics collection
- Create CloudWatch log groups and metric filters
- Set up alarms for different metrics (CPU, memory, disk)
- Create a CloudWatch dashboard for visualization
- Test alarm conditions and observe notifications

---

## 🧰 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.3+ installed
- AWS CLI configured with access credentials
- SSH key pair (if you want to connect to the EC2 instance)

---

## 📁 Files Structure

```
AWS/LAB06-CLOUDWATCH/
├── main.tf                  # Main configuration with TODO sections for students
├── variables.tf             # Variable declarations
├── outputs.tf               # Output definitions
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
├── providers.tf             # Provider configuration
├── solutions.md             # Solutions to the TODOs (for reference)
└── README.md                # Lab instructions
```

---

## ⚠️ Important Setup Notes

1. **Complete the IAM TODO First**: In this lab, the EC2 instance requires an IAM instance profile. You must first complete the "IAM Role and Policy" TODO sections before adding the instance profile reference to the EC2 instance.

2. **Uncomment Outputs**: As you complete each TODO section, you'll need to uncomment the corresponding output in `outputs.tf`. Each output is commented out to prevent Terraform from failing when the related resources don't exist yet.

3. **Sequential Completion**: Follow the TODO sections in order for the best experience, as some resources depend on others you'll create earlier.

---

## 🌐 Architecture Overview

This lab creates a complete CloudWatch monitoring infrastructure:

1. **EC2 Instance**: A web server with the CloudWatch agent installed
2. **CloudWatch Agent**: Collects custom metrics (CPU, memory, disk) and log files
3. **Log Groups**: Stores web access logs, web error logs, and system logs
4. **Metric Filters**: Extracts metrics from logs (e.g., HTTP errors)
5. **Alarms**: Notifies when metrics exceed thresholds
6. **Dashboard**: Visualizes all metrics and logs in one place

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
   cd AWS/LAB06-CLOUDWATCH
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure Infrastructure Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Update your terraform.tfvars file:
   - Set your preferred region (default: eu-west-1)
   - Configure your SSH key pair name
   - Optionally add your email address to receive alarm notifications

### Step 4: Complete the TODO Sections

The main.tf file contains several TODO sections that you need to implement:

1. **IAM Setup**
   - Create an IAM role for CloudWatch access 
   - Attach the CloudWatch agent policy to the role
   - Create an instance profile for the EC2 instance

2. **CloudWatch Log Groups**
   - Create log groups for web access logs, web error logs, and system logs
   - Configure appropriate retention periods and tags

3. **CloudWatch Metric Filters**
   - Create metric filters to extract HTTP error metrics from logs
   - Configure the pattern expressions for 404 and 5xx errors

4. **SNS Setup**
   - Create an SNS topic for alarm notifications
   - Add an email subscription if an email is provided

5. **CloudWatch Alarms**
   - Create alarms for high CPU, memory, and disk usage
   - Set up an alarm for HTTP 404 errors
   - Configure appropriate thresholds and evaluation periods

6. **CloudWatch Dashboard**
   - Create a dashboard with multiple widgets
   - Configure metrics and logs visualizations

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show all the resources to be created:
   - VPC, subnet, and security group
   - EC2 instance with CloudWatch agent
   - IAM role and instance profile
   - CloudWatch log groups and metric filters
   - SNS topic and subscription
   - CloudWatch alarms
   - CloudWatch dashboard

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, note the outputs:
   - EC2 instance public IP
   - CloudWatch dashboard URL
   - Log group names

### Step 7: Explore the CloudWatch Console

1. Navigate to CloudWatch in the AWS Console
2. Explore log groups:
   - Web server access logs
   - Web server error logs
   - System logs
3. Check your dashboard:
   - View the custom dashboard with metrics and logs

### Step 8: Test the CloudWatch Alarms

1. Generate CPU load:
   - SSH into your EC2 instance:
     ```bash
     ssh -i your-key.pem ec2-user@<instance-public-ip>
     ```
   - Run a stress test to trigger CPU alarm:
     ```bash
     sudo stress --cpu 2 --timeout 300
     ```

2. Generate HTTP errors:
   - SSH into your EC2 instance
   - Make curl requests to non-existent pages:
     ```bash
     for i in {1..10}; do curl http://localhost/nonexistent-page-$i; done
     ```

3. Observe alarm state changes:
   - In the AWS Console, go to CloudWatch > Alarms
   - Watch the alarm status change from "OK" to "ALARM"
   - If you configured email notifications, check your inbox

---

## 🔍 Understanding the Components

### IAM Role and Policies
An IAM role allows the EC2 instance to interact with CloudWatch services. The CloudWatchAgentServerPolicy grants permission to send metrics and logs.

### CloudWatch Agent
The CloudWatch agent collects:
- **System metrics**: CPU, memory, disk usage
- **Log files**: Apache access and error logs, system messages

### Log Groups and Metric Filters
Three log groups store different types of logs:
- `/aws/ec2/web/access` - Apache access logs
- `/aws/ec2/web/error` - Apache error logs
- `/aws/ec2/system` - System logs

Metric filters extract metrics from logs, including:
- HTTP 404 errors
- HTTP 5xx errors

### Alarms
CloudWatch alarms monitor metrics and trigger when thresholds are crossed:
- High CPU utilization (> 80%)
- High memory usage (> 80%)
- High disk usage (> 80%)
- HTTP error rate (> 5 errors per 5 minutes)

### Dashboard
The CloudWatch dashboard provides a comprehensive view of:
- CPU, memory, and disk metrics
- HTTP error counts
- Latest web access logs

---

## 📋 Cleanup

To avoid ongoing charges, make sure to destroy the resources created in this lab when you're done:

1. Run the Terraform destroy command:
   ```bash
   terraform destroy
   ```

2. Type `yes` when prompted to confirm the destruction of resources.

3. Verify that all resources have been properly removed:
   ```bash
   # Check if the CloudWatch log groups exist
   aws logs describe-log-groups --log-group-name-prefix /aws/ec2
   
   # Check if the EC2 instance exists
   aws ec2 describe-instances --instance-ids $(terraform output -raw instance_id)
   ```

> ⚠️ **Note**: Destroying resources is permanent. Only do this when you're sure you no longer need the infrastructure.

---

## 💡 Extension Activities

- Add more metric filters for specific log patterns
- Configure composite alarms that combine multiple conditions
- Create a Lambda function that triggers when an alarm fires
- Add anomaly detection to your metrics
- Configure AWS Logs Insights queries for your dashboard

---

## 📚 References

- [CloudWatch Agent Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html)
- [CloudWatch Logs Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
- [CloudWatch Alarms Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html)
- [CloudWatch Dashboards Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)