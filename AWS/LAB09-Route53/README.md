# LAB09: Advanced DNS Management with Amazon Route 53 and Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Amazon Route 53** and **Terraform** to manage DNS for a custom domain. You'll configure various types of DNS records, implement routing policies like failover and weighted distribution, and set up health checks. This lab demonstrates how to automate your DNS infrastructure using infrastructure as code with Terraform, allowing for consistent, repeatable DNS configurations across environments.

---

## 🎯 Learning Objectives

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

## 📁 Files Structure

```
AWS/LAB09-Route53/
├── main.tf                  # Route 53 hosted zone, records, and routing policies with TODOs
├── variables.tf             # Variable definitions for customization
├── outputs.tf               # Output definitions with TODOs
├── providers.tf             # AWS provider configuration
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
├── solutions.md             # Solutions to the TODOs (for reference)
└── README.md                # This documentation file
```

---

## 🌐 Route 53 DNS Architecture

This lab implements a comprehensive DNS management solution with the following components:

1. **Hosted Zone**: The container for all your DNS records
2. **Record Sets**: Different types of DNS records (A, CNAME, MX, TXT, etc.)
3. **Routing Policies**: Failover and weighted distribution rules
4. **Health Checks**: Monitoring endpoint health for failover routing
5. **Alias Records**: Special Route 53 records pointing to AWS services
6. **Subdomain Delegation**: Forwarding DNS management to another hosted zone

These components work together to create a complete DNS management system for your domain.

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB09-Route53
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure DNS Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Customize the configuration in `terraform.tfvars` to adjust:
   - Your domain name (must be one you own)
   - IP addresses for web and API endpoints
   - Email configuration (MX, SPF, DKIM) if needed
   - Optional features like weighted routing or S3/CloudFront integration

   > ⚠️ **Important**: You must own the domain you specify. Attempting to create a hosted zone for a domain you don't control won't allow you to fully complete the lab, as you won't be able to update nameservers at the registrar.

### Step 4: Complete the TODO Sections

This lab contains several TODO sections in main.tf and outputs.tf that you need to complete:

1. In `main.tf`:

   a. **Hosted Zone Creation**
      - Create a public hosted zone for your domain
      - Add appropriate tags and description

   b. **Basic Record Configuration**
      - Create A records for the root domain and www subdomain
      - Set up a CNAME record for the app subdomain
      - Configure appropriate TTL values

   c. **Health Check and Failover**
      - Create a health check for your web endpoint
      - Set up failover routing for the api subdomain
      - Configure primary and secondary records with appropriate settings

   d. **Email Configuration**
      - Add MX, SPF, and DKIM records if enabled
      - Configure a CAA record to restrict certificate authorities

   e. **Advanced Routing**
      - Implement weighted routing for A/B testing
      - Set up alias records for AWS services
      - Configure subdomain delegation with NS records

2. In `outputs.tf`:
   - Define outputs for hosted zone information
   - Create outputs for record configurations
   - Set up helpful commands and instructions for verification

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the resources to be created:
   - Route 53 hosted zone for your domain
   - Various DNS records (A, CNAME, MX, TXT, etc.)
   - Health check configuration
   - Routing policies for advanced scenarios

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, Terraform will display outputs including:
   - Nameservers for your hosted zone (important for the next step)
   - Summary of created records
   - Commands to verify DNS configuration

### Step 7: Update Your Domain Registrar

1. Log in to your domain registrar (where you purchased your domain):
   - For example: Namecheap, GoDaddy, Route 53, etc.

2. Locate the DNS or nameserver settings for your domain

3. Replace the existing nameservers with the AWS nameservers:
   - Copy the nameservers from the Terraform output
   - Update them at your registrar
   - Save the changes

   > ⚠️ **Note**: This step is critical. Your domain will not resolve to your Route 53 configuration until you complete this step at your registrar.

4. Wait for DNS propagation (can take 24-48 hours)

### Step 8: Verify Your Configuration

1. Check the nameserver update:
   ```bash
   # Use the command provided in the Terraform output
   dig NS yourdomain.com +short
   ```

2. Verify DNS records:
   ```bash
   # Check A record for root domain
   dig yourdomain.com +short
   
   # Check CNAME record for app subdomain
   dig app.yourdomain.com +short
   
   # Check health check status
   aws route53 get-health-check --health-check-id $(terraform output -raw health_check_id)
   ```

3. View the hosted zone in the AWS Console:
   - Navigate to Route 53 in the AWS Console
   - Click on "Hosted zones"
   - Select your domain
   - Review the records and configurations

---

## 🔍 Understanding Route 53 DNS Architecture

### DNS Resolution Flow Diagram

```
    User
     |
     | 1. Request: what is the IP for example.com?
     v
+------------------------+
|    DNS Resolver        |
| (ISP or Public DNS)    |
+------------------------+
     |
     | 2. Query root nameservers
     v
+------------------------+
|  Root Nameservers      |
| (.com, .org, .net)     |
+------------------------+
     |
     | 3. Query TLD nameservers
     v
+------------------------+
|  TLD Nameservers       |
| (Manages .com domains) |
+------------------------+
     |
     | 4. Query authoritative nameservers (Route 53)
     v
+------------------------+
|  Route 53 Nameservers  |
| (AWS's DNS Service)    |
+------------------------+
     |
     | 5. Return record based on routing policy
     v
+-----------------------------+
| Routing Policy Evaluation  |
| - Simple: Direct mapping   |
| - Failover: Health-based   |
| - Weighted: Distribution   |
| - Alias: AWS service       |
+-----------------------------+
     |
     | 6. Return appropriate IP/value
     v
    User
     |
     | 7. Connect to resolved IP
     v
+--------------------------+
| Target Resource          |
| (Web server, S3, etc.)   |
+--------------------------+
```

### Key Components Explained

1. **Hosted Zone**: Container for your domain's DNS records
   ```hcl
   resource "aws_route53_zone" "main" {
     name    = var.domain_name
     comment = "Managed by Terraform - Route 53 Lab"
     tags = {
       Name = var.domain_name
       # Additional tags...
     }
   }
   ```

2. **A Records**: Maps a domain to an IPv4 address
   ```hcl
   resource "aws_route53_record" "root_a" {
     zone_id = aws_route53_zone.main.zone_id
     name    = var.domain_name
     type    = "A"
     ttl     = 300
     records = [var.web_ip]
   }
   ```

3. **CNAME Records**: Maps a subdomain to another domain
   ```hcl
   resource "aws_route53_record" "app_cname" {
     zone_id = aws_route53_zone.main.zone_id
     name    = "app.${var.domain_name}"
     type    = "CNAME"
     ttl     = 300
     records = [var.web_endpoint]
   }
   ```

4. **Health Checks**: Monitors endpoint health
   ```hcl
   resource "aws_route53_health_check" "web_health_check" {
     fqdn              = var.web_endpoint
     port              = 80
     type              = "HTTP"
     resource_path     = "/"
     failure_threshold = 3
     request_interval  = 30
     # Tags...
   }
   ```

5. **Failover Routing**: Redirects traffic based on health
   ```hcl
   # Primary record (used when healthy)
   resource "aws_route53_record" "api_a" {
     zone_id         = aws_route53_zone.main.zone_id
     name            = "api.${var.domain_name}"
     type            = "A"
     set_identifier  = "primary"
     health_check_id = aws_route53_health_check.web_health_check.id
     
     failover_routing_policy {
       type = "PRIMARY"
     }
     
     ttl     = 300
     records = [var.api_primary_ip]
   }
   
   # Secondary record (used when primary is unhealthy)
   resource "aws_route53_record" "api_a_secondary" {
     # Configuration for secondary record...
     failover_routing_policy {
       type = "SECONDARY"
     }
   }
   ```

---

## 💡 Key Learning Points

1. **Route 53 DNS Management Principles**:
   - Using hosted zones to manage domain records
   - Implementing different record types for specific purposes
   - Setting appropriate TTL values for caching control
   - Delegating subdomains for distributed management
   - Connecting domains to AWS services with alias records

2. **Advanced Routing Concepts**:
   - Failover routing for high availability
   - Weighted routing for A/B testing and gradual deployments
   - Health checks for automated traffic routing
   - Record-specific routing policies for different needs

3. **Terraform Techniques**:
   - Creating conditional resources with count
   - Working with complex record types
   - Managing multiple related DNS resources
   - Using data structures to organize record data

4. **DNS Security Best Practices**:
   - Implementing DNSSEC for authentication
   - Using CAA records to restrict certificate issuers
   - Setting up SPF and DKIM for email security
   - Understanding DNS propagation and cache behavior

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Implement Geolocation Routing**:
   Set up routing based on user location
   ```hcl
   resource "aws_route53_record" "geo_record" {
     zone_id        = aws_route53_zone.main.zone_id
     name           = "geo.${var.domain_name}"
     type           = "A"
     set_identifier = "europe"
     
     geolocation_routing_policy {
       continent = "EU"
     }
     
     ttl     = 300
     records = ["192.0.2.10"] # European server
   }
   ```

2. **Enable DNSSEC for Authentication**:
   Secure your hosted zone with DNSSEC
   ```hcl
   resource "aws_route53_key_signing_key" "example" {
     hosted_zone_id             = aws_route53_zone.main.id
     key_management_service_arn = aws_kms_key.dnssec.arn
     name                       = "example"
   }
   
   resource "aws_route53_hosted_zone_dnssec" "example" {
     hosted_zone_id = aws_route53_key_signing_key.example.hosted_zone_id
   }
   ```

3. **Create Multi-Value Answer Records**:
   Route traffic to multiple resources
   ```hcl
   resource "aws_route53_record" "multi_value" {
     zone_id        = aws_route53_zone.main.zone_id
     name           = "multi.${var.domain_name}"
     type           = "A"
     set_identifier = "server1"
     
     multivalue_answer_policy = true
     
     ttl     = 300
     records = ["192.0.2.20"]
   }
   ```

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. Restore your domain's nameservers at your registrar (optional):
   - If you want to continue using your domain with a different DNS provider
   - Log in to your domain registrar
   - Restore the original nameservers or point to a different DNS provider

2. When ready, destroy the infrastructure:
   ```bash
   terraform destroy
   ```

3. Type `yes` when prompted to confirm.

4. Verify that the hosted zone has been deleted:
   ```bash
   # Check if the hosted zone still exists
   aws route53 list-hosted-zones --query "HostedZones[?Name=='${var.domain_name}.'].Id" --output text
   
   # If no output, the hosted zone has been deleted
   ```

5. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars
   ```

> ⚠️ **Important Note**: If you don't update your domain's nameservers at the registrar after destroying the Route 53 hosted zone, your domain may become unreachable. Ensure you've properly configured your domain's DNS before or after running `terraform destroy`.

---

## 🚫 Common Errors and Troubleshooting

1. **Domain Still Using Old Nameservers**:
   ```
   $ dig NS yourdomain.com
   # Shows non-AWS nameservers
   ```
   **Solution**: Verify you've updated nameservers at your domain registrar and wait for propagation (up to 48 hours).

2. **Health Check Failing**:
   ```
   Error: Health checks report resource is unhealthy
   ```
   **Solution**: Ensure target endpoint is running and accessible, check firewall rules, and verify the health check configuration.

3. **Record Set Creation Failure**:
   ```
   Error: Error creating Route53 record set: InvalidChangeBatch: [Tried to create resource record set...
   ```
   **Solution**: Check for duplicate records or conflicts, ensure record type matches the data format, and verify you own the domain.

4. **CNAME at Zone Apex**:
   ```
   Error: Error creating Route53 record set: InvalidChangeBatch: CNAME records are not allowed for zone apex
   ```
   **Solution**: Use an A record with an Alias for the root domain, not a CNAME.

5. **Missing Nameserver Records**:
   ```
   Error when looking up NS records for yourdomain.com
   ```
   **Solution**: Ensure the hosted zone exists and wait for AWS to create NS records (usually immediate, but can take a few minutes).

6. **CAA Record Format Issues**:
   ```
   Error: Error creating Route53 record set: InvalidChangeBatch: Invalid CAA record
   ```
   **Solution**: Verify CAA record format, especially quotes and flag values.

---

## 📚 Additional Resources

- [Amazon Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [Terraform AWS Provider - Route 53 Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)
- [IANA Root Zone Database](https://www.iana.org/domains/root/db) - Authoritative list of TLDs
- [DNS Made Easy Resource Center](https://dnsmadeeasy.com/support/resourcecenter) - Educational DNS articles
- [ICANN - Domain Name System](https://www.icann.org/resources/pages/dns-2013-03-22-en) - DNS overview and resources
- [DNSMap Tool](https://dnsmap.io/) - Visual DNS mapping and debugging
- [DNS Propagation Checker](https://www.whatsmydns.net/) - Check DNS resolution around the world

---

## 🚀 Next Lab

Proceed to [LAB10-Lambda](../LAB10-Lambda/) to learn how to deploy serverless functions and create event-driven architectures using AWS Lambda.

---

Happy Terraforming!