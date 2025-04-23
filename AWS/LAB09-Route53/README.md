# LAB09: Advanced DNS Management with Amazon Route 53 and Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Amazon Route 53** and **Terraform** to manage DNS for a custom domain. You'll configure various types of DNS records, implement routing policies like failover and weighted distribution, and set up health checks. This lab demonstrates how to automate your DNS infrastructure using infrastructure as code with Terraform, allowing for consistent, repeatable DNS configurations across environments.

---

## 🎯 Objectives

- Create a Route 53 public hosted zone for a custom domain
- Configure various DNS record types (A, CNAME, MX, TXT, CAA)
- Implement advanced routing policies (failover, weighted)
- Create health checks for high-availability configurations
- Set up subdomain delegation
- Connect custom domains to AWS services like S3 and CloudFront
- Update domain registrar with Route 53 nameservers

---

## 🧰 Prerequisites

- A registered domain name (from a domain registrar like Namecheap, GoDaddy, or Route 53)
- AWS account with Route 53 access permissions
- Terraform v1.3+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of DNS concepts (records, propagation, TTL)

---

## 📁 File Structure

```bash
AWS/LAB09-Route53/
├── main.tf          # Route 53 hosted zone, records, and routing policies
├── variables.tf     # Variable definitions for customization
├── outputs.tf       # Output values for DNS information
├── terraform.tfvars # Variable values configuration
└── README.md        # This documentation file
```

---

## 🚀 Steps to Complete the Lab

### 1. Prepare Your Environment

1. **Update the terraform.tfvars file**
   - Set your actual domain name
   - Configure IP addresses and endpoints for your web services
   - Enable optional record types as needed (MX, SPF, DKIM)
   - Configure advanced routing settings if desired

### 2. Deploy Your DNS Configuration

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review the deployment plan**
   ```bash
   terraform plan
   ```

3. **Apply the configuration**
   ```bash
   terraform apply
   ```

4. **Record the outputs**
   - Nameservers for your hosted zone
   - Record configurations
   - AWS CLI commands for verification

### 3. Update Your Domain Registrar

1. **Log in to your domain registrar**
   - Namecheap, GoDaddy, or wherever your domain is registered

2. **Update nameservers**
   - Find the DNS or nameserver settings for your domain
   - Replace the existing nameservers with the AWS nameservers from the Terraform output
   - Save changes

3. **Wait for DNS propagation**
   - DNS changes can take 24-48 hours to fully propagate
   - You can check status with: `dig NS yourdomain.com +short`

### 4. Verify Your DNS Configuration

1. **Check record creation**
   ```bash
   aws route53 list-resource-record-sets --hosted-zone-id <hosted-zone-id>
   ```

2. **Test DNS resolution**
   ```bash
   dig A www.yourdomain.com
   dig CNAME app.yourdomain.com
   ```

3. **Check health check status** (if configured)
   ```bash
   aws route53 get-health-check --health-check-id <health-check-id>
   ```

4. **Access your domain**
   - Open a web browser and navigate to your domain
   - If pointing to a web server, you should see your website

---

## 🔍 DNS Record Types Explained

| Record Type | Purpose | Example |
|-------------|---------|---------|
| **A** | Maps a domain to an IPv4 address | example.com → 203.0.113.10 |
| **AAAA** | Maps a domain to an IPv6 address | example.com → 2001:0db8:85a3:0000:0000:8a2e:0370:7334 |
| **CNAME** | Maps a subdomain to another domain | app.example.com → lb-123.elb.amazonaws.com |
| **MX** | Specifies mail servers for the domain | example.com → 10 mail.example.com |
| **TXT** | Holds text information (often for verification) | example.com → "v=spf1 include:_spf.google.com ~all" |
| **NS** | Specifies nameservers for the domain | example.com → ns-123.awsdns-15.net |
| **CAA** | Specifies which CAs can issue certificates | example.com → 0 issue "amazonaws.com" |

---

## 🌐 Route 53 Routing Policies

This lab implements several advanced routing policies:

### Simple Routing
Basic mapping of a domain to a resource. Used for the root domain and www subdomain.

### Failover Routing
Directs traffic based on health checks:
- Primary endpoint receives traffic when healthy
- Secondary endpoint receives traffic when primary is unhealthy
Applied to the api.example.com subdomain in this lab.

### Weighted Routing
Distributes traffic based on assigned weights:
- Useful for A/B testing or gradual deployments
- Our lab configures 80% to version A and 20% to version B for test.example.com

### Alias Records
Special Route 53 record type that points to AWS resources:
- Can target S3 websites, CloudFront distributions, etc.
- Zero cost for queries to AWS resources

---

## 🧼 Cleanup

When you've completed the lab, destroy all resources to avoid incurring additional costs:

```bash
terraform destroy
```

**Note**: This will only remove the Route 53 configuration from AWS. Your domain registration will remain active at your registrar, and you'll need to update the nameservers there if you want to use the domain with another DNS provider.

---

## 💡 Advanced Extensions

Take your learning further with these advanced challenges:

1. **Implement Geolocation Routing**
   - Route users to different endpoints based on their geographic location

2. **Set Up DNSSEC Signing**
   - Enable DNSSEC to add cryptographic signatures to DNS records for security

3. **Create a Private Hosted Zone**
   - Set up DNS for internal-only resources within a VPC

4. **Implement Latency-Based Routing**
   - Direct users to the AWS region with the lowest latency

5. **Configure DNS-Based Service Discovery**
   - Use Route 53 Auto Naming or AWS Cloud Map for microservices

---

## 📚 References

- [Amazon Route 53 Documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [Terraform AWS Provider - Route 53 Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)
- [DNS and BIND, 5th Edition](https://www.oreilly.com/library/view/dns-and-bind/0596100574/) - Comprehensive DNS reference
- [AWS DNS Best Practices](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/route-53-best-practices.html)
- [Understanding DNS TTL](https://ns1.com/resources/understanding-dns-ttl)

---

## ✅ Key Takeaways

After completing this lab, you'll understand how to:

- Automate DNS management using Terraform and Route 53
- Configure multiple record types for different purposes
- Implement advanced routing strategies for high availability
- Set up health checks to ensure service reliability
- Connect custom domains to various AWS services
- Update domain registrar settings to delegate DNS to AWS
- Manage complex DNS configurations as code