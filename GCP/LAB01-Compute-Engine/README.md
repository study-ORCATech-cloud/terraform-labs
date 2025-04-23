# LAB01: Launch a Compute Engine VM with Terraform

## 📝 Lab Overview

In this lab, you’ll deploy a **Compute Engine VM instance** on **Google Cloud Platform (GCP)** using **Terraform**. This introduces core GCP services and helps you understand VM deployment via Infrastructure as Code.

---

## 🎯 Objectives

- Configure the GCP provider
- Launch a VM instance with a specified machine type and image
- Output the instance’s external IP address for SSH access

---

## 🧰 Prerequisites

- GCP project with billing enabled
- Terraform v1.3+ installed
- `gcloud` CLI authenticated (`gcloud auth application-default login`)

---

## 📁 File Structure

```bash
GCP/LAB01-Compute-Engine/
├── main.tf               # VM instance configuration
├── variables.tf          # Zone, machine type, etc.
├── outputs.tf            # External IP address
├── terraform.tfvars      # Optional input values
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Initialize and plan Terraform**
```bash
terraform init
terraform plan
```

2. **Apply the configuration**
```bash
terraform apply
```

3. **SSH into your instance**
```bash
ssh -i ~/.ssh/YOUR_KEY_NAME USER@<external_ip>
```

---

## 🧼 Cleanup

```bash
terraform destroy
```
Be sure to delete the VM to avoid charges

---

## 💡 Key Concepts

- **Compute Engine**: GCP’s IaaS offering for virtual machines
- **Machine Image**: Defines the OS and configuration (e.g. Debian, Ubuntu)
- **Zone/Region**: Specifies where resources are deployed
- **SSH Keys**: Provide secure login to the VM

---

## 🧪 Optional Challenges

- Deploy a startup script that installs NGINX
- Use a custom service account for the VM
- Restrict firewall access to specific IPs (advanced)

---

## 📚 References

- [Terraform GCP Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Compute Engine Docs](https://cloud.google.com/compute/docs)

---

## ✅ Summary

You’ve successfully deployed your first Compute Engine instance using Terraform. This is a foundational skill for infrastructure provisioning on GCP.

**Next up:** Create and manage Cloud Storage buckets in LAB02.

