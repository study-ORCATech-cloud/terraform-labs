# LAB06: Advanced AWS CloudWatch Monitoring and Alerting with Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Terraform** to deploy a complete CloudWatch monitoring solution. You'll set up an EC2 instance with the CloudWatch agent, create log groups, configure metric filters, set up alarms, and build a custom dashboard to visualize all your monitoring data.

This hands-on lab will guide you through the process of implementing a proper monitoring and alerting infrastructure using Infrastructure as Code (IaC) principles.

---

## 🎯 Objectives

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

## 📁 File Structure

```bash
AWS/LAB06-CLOUDWATCH/
├── main.tf               # Primary Terraform configuration with TODO sections
├── variables.tf          # Variable definitions
├── outputs.tf            # Output values
├── terraform.tfvars      # Variable values
├── solutions.md          # Solutions to the TODOs (for instructor reference)
└── README.md             # This documentation
```

---

## 🚀 Steps to Complete the Lab

### 1. Prepare Your Environment

1. **Review the terraform.tfvars file**
   - Set your preferred region (default: eu-west-1)
   - Configure your SSH key pair name
   - Optionally add your email address to receive alarm notifications

### 2. Complete the TODO Sections in main.tf

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

### 3. Deploy Resources

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Preview the deployment plan**
   ```bash
   terraform plan
   ```

3. **Apply the configuration**
   ```bash
   terraform apply
   ```

4. **Note the outputs**
   - EC2 instance public IP
   - CloudWatch dashboard URL
   - Log group names

### 4. Explore the CloudWatch Console

1. **Navigate to CloudWatch in the AWS Console**
2. **Explore log groups**
   - Web server access logs
   - Web server error logs
   - System logs
3. **Check your dashboard**
   - View the custom dashboard with metrics and logs

### 5. Test the CloudWatch Alarms

1. **Generate CPU load**
   - SSH into your EC2 instance:
     ```bash
     ssh -i your-key.pem ec2-user@<instance-public-ip>
     ```
   - Run a stress test to trigger CPU alarm:
     ```bash
     sudo stress --cpu 2 --timeout 300
     ```

2. **Generate HTTP errors**
   - SSH into your EC2 instance
   - Make curl requests to non-existent pages:
     ```bash
     for i in {1..10}; do curl http://localhost/nonexistent-page-$i; done
     ```

3. **Observe alarm state changes**
   - In the AWS Console, go to CloudWatch > Alarms
   - Watch the alarm status change from "OK" to "ALARM"
   - If you configured email notifications, check your inbox

---

## 🔍 Key Components to Implement

### IAM Role and Policies
You'll need to create an IAM role that allows the EC2 instance to interact with CloudWatch services. The role needs to have the CloudWatchAgentServerPolicy attached to grant permission to send metrics and logs.

### CloudWatch Agent
The lab includes an EC2 instance with the CloudWatch agent pre-configured in the user data. The agent collects:
- **System metrics**: CPU, memory, disk usage
- **Log files**: Apache access and error logs, system messages

### Log Groups and Metric Filters
You'll need to create three log groups:
- `/aws/ec2/web/access` - Apache access logs
- `/aws/ec2/web/error` - Apache error logs
- `/aws/ec2/system` - System logs

You'll also implement metric filters to extract metrics from logs, including:
- HTTP 404 errors
- HTTP 5xx errors

### Alarms
You'll configure CloudWatch alarms for:
- High CPU utilization (> 80%)
- High memory usage (> 80%)
- High disk usage (> 80%)
- HTTP error rate (> 5 errors per minute)

### Dashboard
You'll create a comprehensive dashboard that displays:
- CPU, memory, and disk metrics
- HTTP error counts
- Latest web access logs

---

## 🧼 Cleanup

When you're finished with the lab, you should destroy all created resources to avoid unexpected AWS charges.

```bash
terraform destroy
```

This will remove all CloudWatch log groups, metric filters, alarms, dashboards, and the EC2 instance created during this lab.

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
- [CloudWatch Metrics Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)
- [CloudWatch Logs Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## ✅ Key Takeaways

After completing this lab, you'll understand how to:

- Implement comprehensive monitoring for AWS resources
- Configure automated alerting for system and application issues
- Collect and analyze logs and metrics using CloudWatch
- Create dashboards for real-time visibility into your infrastructure
- Automate the entire monitoring setup using Infrastructure as Code (Terraform)