# LAB09: Configure DNS and Custom Domain with Cloud DNS using Terraform

## 📝 Lab Overview

In this lab, you’ll use **Terraform** to configure a **Cloud DNS** zone and map a **custom domain** to GCP resources. This allows routing traffic to services via clean, branded URLs.

---

## 🎯 Objectives

- Create a public DNS zone
- Add A, CNAME, and TXT records
- Delegate domain to GCP name servers

---

## 🧰 Prerequisites

- GCP project and a domain registered externally (e.g., Namecheap)
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB09-CloudDNS-Domain/
├── main.tf               # DNS zone and records
├── variables.tf          # Domain name, TTLs, record values
├── outputs.tf            # NS records and domain test info
├── terraform.tfvars      # Optional overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Set your domain name in `terraform.tfvars`**
2. **Deploy the zone and records**
```bash
terraform init
terraform apply
```

3. **Update your domain registrar** with GCP name servers
4. **Test domain routing** with `nslookup`, `dig`, or browser

---

## 🧼 Cleanup

```bash
terraform destroy
```
Be careful with production domain names

---

## 💡 Key Concepts

- **DNS Zone**: Hosts all DNS records for a domain
- **A / CNAME Records**: Point to IP addresses or domains
- **NS / TXT Records**: Used for delegation and verification

---

## 🧪 Optional Challenges

- Configure SPF/DKIM for email validation
- Use `google_dns_record_set` for multi-record batches
- Add alias records for Load Balancers

---

## 📚 References

- [Terraform Cloud DNS Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone)
- [GCP DNS Documentation](https://cloud.google.com/dns/docs)

---

## ✅ Summary

You’ve now mapped a domain using Cloud DNS and Terraform. This skill enables DNS automation, vital for web apps, APIs, and SaaS platforms.

**Next up:** Build and deploy a serverless API with Cloud Functions in LAB10.

