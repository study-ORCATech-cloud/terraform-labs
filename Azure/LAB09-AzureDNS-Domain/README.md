# LAB09: Configure Custom Domain and DNS with Azure DNS using Terraform

## 📝 Lab Overview

In this lab, you'll provision a **DNS zone** using **Azure DNS** and configure records to link a **custom domain** to Azure services — such as VMs, storage, or external IPs.

---

## 🎯 Objectives

- Create a DNS zone for a registered domain
- Add A, CNAME, and TXT records
- Delegate domain to Azure’s name servers

---

## 🧰 Prerequisites

- A domain registered with a third-party registrar
- Terraform v1.3+ installed
- Azure CLI authenticated (`az login`)

---

## 📁 File Structure

```bash
Azure/LAB09-AzureDNS-Domain/
├── main.tf               # DNS zone and record sets
├── variables.tf          # Domain name, records
├── outputs.tf            # NS records, verification info
├── terraform.tfvars      # Optional values for testing
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Define domain in `terraform.tfvars`**
2. **Initialize and apply configuration**
```bash
terraform init
terraform apply
```

3. **Update your domain registrar** with Azure NS records

4. **Test domain** using `nslookup`, browser, or `dig`

---

## 🧼 Cleanup

```bash
terraform destroy
```
Be careful with production domain zones

---

## 💡 Key Concepts

- **DNS Zone**: Hosts record sets for a domain
- **NS Records**: Direct DNS traffic to Azure DNS
- **Record Set**: Includes A, AAAA, CNAME, TXT, MX, etc.

---

## 🧪 Optional Challenges

- Add SPF/DKIM for email validation
- Use alias record to point to an Azure service
- Add TTL configurations for faster/longer propagation

---

## 📚 References

- [Terraform Azure DNS Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_zone)
- [Azure DNS Guide](https://learn.microsoft.com/en-us/azure/dns/)

---

## ✅ Summary

You've now mapped a custom domain using Azure DNS and Terraform. This enables professional URLs and secure access to Azure-hosted services.

**Next up:** Deploy your first Azure Function with HTTP endpoint in LAB10.

