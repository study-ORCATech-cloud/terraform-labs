# LAB09: Manage DNS and Custom Domains with Route 53 using Terraform

## 📝 Lab Overview

In this lab, you'll configure **DNS records and custom domain routing** using **Amazon Route 53** and **Terraform**. This enables traffic to flow to services like EC2 or S3 through clean, branded domain names.

---

## 🎯 Objectives

- Create a public hosted zone for a custom domain
- Add A, CNAME, and optionally MX or TXT records
- Delegate domain from registrar to AWS Route 53

---

## 🧰 Prerequisites

- Registered domain name (e.g. from Namecheap, GoDaddy)
- Terraform v1.3+ installed

---

## 📁 File Structure

```bash
AWS/LAB09-Route53/
├── main.tf               # Hosted zone and DNS records
├── variables.tf          # Domain name, IPs, subdomains
├── outputs.tf            # Nameservers, URLs
├── terraform.tfvars      # Optional values for domain/subdomains
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Define domain in `terraform.tfvars`** or pass via CLI
2. **Initialize Terraform**
   ```bash
   terraform init
   ```
3. **Apply configuration**
   ```bash
   terraform apply
   ```
4. **Copy name servers** and update at your domain registrar
5. **Test routing** (ping, curl, or browser)

---

## 🧼 Cleanup

```bash
terraform destroy
```

---

## 💡 Key Concepts

- **Hosted Zone**: AWS-managed DNS zone for a domain
- **A Record**: Maps domain to an IP
- **CNAME**: Maps subdomain to another domain
- **NS/TXT/MX**: Nameservers, email configs, verification data

---

## 🧪 Optional Challenges

- Add SPF/DKIM TXT records for email services
- Add health check for A record targets
- Route subdomains to different services (S3, EC2, CloudFront)

---

## 📚 References

- [Terraform Route 53 Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)
- [Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/)

---

## ✅ Summary

You’ve now used Terraform to manage DNS with Route 53, making it easy to map domains to AWS services in a reusable and automated way.

**Next up:** Create a serverless API with Lambda and API Gateway in LAB10.