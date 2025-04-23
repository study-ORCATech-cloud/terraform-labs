# LAB06: Monitor Logs and Metrics with CloudWatch and Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to configure **Amazon CloudWatch Logs**, **metrics**, and **alarms**. You'll create log groups, push data, and set alarms for automatic monitoring of system performance.

---

## 🎯 Objectives

- Create CloudWatch log groups and metric filters
- Configure alarms on EC2 CPU or memory usage
- Test alarm conditions and trigger notifications

---

## 🧰 Prerequisites

- EC2 instance (standalone or part of ASG from LAB05)
- Terraform v1.3+ installed

---

## 📁 File Structure

```bash
AWS/LAB06-CLOUDWATCH/
├── main.tf               # CloudWatch logs, metrics, alarms
├── variables.tf          # Log group names, instance IDs, etc.
├── outputs.tf            # Alarm names, log stream names
├── terraform.tfvars      # Optional variable overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Run plan and apply**
   ```bash
   terraform plan
   terraform apply
   ```

3. **Test alarms** by simulating load on EC2 (e.g., stress test)

---

## 🧼 Cleanup

```bash
terraform destroy
```
To remove log groups and alarms

---

## 💡 Key Concepts

- **Log Group**: Container for logs pushed by EC2 or other services
- **Metric Filter**: Turns logs into quantifiable metrics
- **Alarm**: Watch a metric and send alerts on thresholds
- **SNS**: Can be integrated to send emails or SMS

---

## 🧪 Optional Challenges

- Create dashboard with widgets (CPU, memory, logs)
- Use CloudWatch agent to push logs
- Set custom alarm on disk space or network

---

## 📚 References

- [Terraform CloudWatch Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)
- [AWS CloudWatch Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/)

---

## ✅ Summary

You've implemented automated observability using CloudWatch and Terraform — critical for proactive infrastructure monitoring.

**Next up:** Launch a managed MySQL database using RDS in LAB07.