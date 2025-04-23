# LAB06: Monitor Azure Resources with Azure Monitor and Log Analytics

## 📝 Lab Overview

In this lab, you'll integrate your Azure resources with **Azure Monitor** and **Log Analytics** using **Terraform**. You’ll create metrics alerts and query logs for insights and troubleshooting.

---

## 🎯 Objectives

- Create a Log Analytics Workspace
- Enable diagnostics for Azure resources
- Create a metric-based alert rule with email notification

---

## 🧰 Prerequisites

- Azure account with Monitoring Contributor access
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB06-Monitor-LogAnalytics/
├── main.tf               # Monitor, diagnostics, alert rules
├── variables.tf          # Workspace name, thresholds, etc.
├── outputs.tf            # Alert name, workspace ID
├── terraform.tfvars      # Input overrides (optional)
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and configure Terraform**
```bash
terraform init
terraform plan
terraform apply
```

2. **Simulate metrics (e.g., CPU usage)** to test alerts

3. **Query logs** from the Log Analytics workspace

---

## 🧼 Cleanup

```bash
terraform destroy
```
This will delete all monitoring and alert resources

---

## 💡 Key Concepts

- **Log Analytics Workspace**: Stores logs and telemetry data
- **Diagnostic Settings**: Push logs/metrics to workspace
- **Alert Rules**: Trigger actions based on thresholds
- **Action Groups**: Define notification targets (email, SMS)

---

## 🧪 Optional Challenges

- Create dashboards with charts and logs
- Send data to Azure Monitor Metrics Explorer
- Use Kusto Query Language (KQL) to analyze data

---

## 📚 References

- [Terraform Monitor Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert)
- [Azure Monitor Docs](https://learn.microsoft.com/en-us/azure/azure-monitor/)

---

## ✅ Summary

You've now enabled observability on Azure using Monitor and Log Analytics. This empowers you to proactively respond to performance issues.

**Next up:** Provision a managed relational database with Azure SQL in LAB07.

