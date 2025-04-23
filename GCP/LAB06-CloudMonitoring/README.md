# LAB06: Monitor Resources with Cloud Monitoring and Logging in GCP using Terraform

## 📝 Lab Overview

In this lab, you’ll set up **Cloud Monitoring** and **Cloud Logging** for GCP resources using **Terraform**. You'll create alert policies and dashboards to track metrics and troubleshoot issues in real time.

---

## 🎯 Objectives

- Enable GCP Monitoring API
- Create alert policies for CPU or network usage
- View logs and metrics for GCE or MIG instances

---

## 🧰 Prerequisites

- GCP project with billing and API access
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB06-CloudMonitoring/
├── main.tf               # Alerting, dashboard, logging config
├── variables.tf          # Thresholds, labels, project ID
├── outputs.tf            # Alert names, dashboard link
├── terraform.tfvars      # Optional variable inputs
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and apply**
```bash
terraform init
terraform apply
```

2. **Generate test load on VM** to trigger alert
3. **View logs and metrics** in the Cloud Console

---

## 🧼 Cleanup

```bash
terraform destroy
```
Removes alerts, dashboards, and logging configs

---

## 💡 Key Concepts

- **Cloud Monitoring**: GCP’s platform for metrics, dashboards, alerts
- **Alert Policy**: Defines conditions for notification
- **Cloud Logging**: Captures stdout/stderr and system logs

---

## 🧪 Optional Challenges

- Send alert notifications to email or Slack
- Create custom dashboards with charts
- Monitor GKE clusters (advanced)

---

## 📚 References

- [Terraform Monitoring Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy)
- [GCP Cloud Monitoring](https://cloud.google.com/monitoring)

---

## ✅ Summary

You've now created observability infrastructure in GCP using Terraform. Monitoring is crucial for maintaining performance and reliability in cloud environments.

**Next up:** Deploy a managed PostgreSQL database with Cloud SQL in LAB07.