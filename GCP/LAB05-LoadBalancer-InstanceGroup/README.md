# LAB05: Configure Load Balancer and Managed Instance Group in GCP using Terraform

## 📝 Lab Overview

In this lab, you’ll deploy a **Managed Instance Group (MIG)** behind a **HTTP Load Balancer** using **Terraform**. This enables automatic scaling and traffic distribution for stateless applications.

---

## 🎯 Objectives

- Create a managed instance template and group
- Deploy a global HTTP Load Balancer
- Configure health checks and backend services

---

## 🧰 Prerequisites

- GCP project with Compute Engine and Load Balancing APIs enabled
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB05-LoadBalancer-InstanceGroup/
├── main.tf               # Instance group, load balancer
├── variables.tf          # Instance config, port, health checks
├── outputs.tf            # Load balancer IP and URLs
├── terraform.tfvars      # Optional overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and plan**
```bash
terraform init
terraform plan
```

2. **Apply the configuration**
```bash
terraform apply
```

3. **Access the Load Balancer’s frontend IP**
```bash
curl http://<external-ip>
```

---

## 🧼 Cleanup

```bash
terraform destroy
```
Deletes the instance group and load balancer

---

## 💡 Key Concepts

- **Instance Template**: Blueprint for MIG VM instances
- **Managed Instance Group**: Automatically scales identical VMs
- **Health Check**: Monitors instance health
- **Backend Service**: Routes requests from the load balancer

---

## 🧪 Optional Challenges

- Use custom startup scripts to serve content
- Add multiple instance groups in different zones
- Add HTTPS support with self-signed cert

---

## 📚 References

- [Terraform MIG Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_group_manager)
- [GCP Load Balancing Docs](https://cloud.google.com/load-balancing/)

---

## ✅ Summary

You’ve now implemented a scalable, load-balanced application layer in GCP using Terraform. This architecture is production-ready and resilient by design.

**Next up:** Implement monitoring and alerting with Cloud Monitoring in LAB06.