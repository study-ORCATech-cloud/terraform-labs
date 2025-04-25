# LAB09: Route 53 DNS Management Solutions

This document provides solutions for the Route 53 DNS Management lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "aws" {
  region = var.region
}

# Create a Route 53 public hosted zone for the domain
resource "aws_route53_zone" "main" {
  name    = var.domain_name
  comment = "Managed by Terraform - Route 53 Lab"

  tags = {
    Environment = "Lab"
    Name        = var.domain_name
    Project     = "Terraform-Labs"
  }
}

# Create a health check for the web server
resource "aws_route53_health_check" "web_health_check" {
  fqdn              = var.web_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "web-health-check"
  }
}

# Create an A record for the root domain pointing to web_ip
resource "aws_route53_record" "root_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [var.web_ip]
}

# Create an A record for "www" subdomain pointing to web_ip
resource "aws_route53_record" "www_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.web_ip]
}

# Create a CNAME record for "app" subdomain pointing to web_endpoint
resource "aws_route53_record" "app_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.web_endpoint]
}

# Create a health-checked A record for "api" subdomain
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

# Create a secondary failover record for "api" subdomain
resource "aws_route53_record" "api_a_secondary" {
  zone_id        = aws_route53_zone.main.zone_id
  name           = "api.${var.domain_name}"
  type           = "A"
  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

  ttl     = 300
  records = [var.api_secondary_ip]
}

# Create MX records for email (if enabled)
resource "aws_route53_record" "mx" {
  count   = var.create_mx_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = 3600
  records = [
    "1 ${var.mx_server_primary}",
    "5 ${var.mx_server_secondary}",
    "10 ${var.mx_server_tertiary}"
  ]
}

# Create TXT record for SPF (email sender policy framework)
resource "aws_route53_record" "spf" {
  count   = var.create_spf_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 3600
  records = ["v=spf1 include:${var.spf_include} ~all"]
}

# Create DKIM records for email authentication (if enabled)
resource "aws_route53_record" "dkim" {
  count   = var.create_dkim_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.dkim_selector}._domainkey.${var.domain_name}"
  type    = "TXT"
  ttl     = 3600
  records = [var.dkim_value]
}

# Create CAA (Certificate Authority Authorization) records
resource "aws_route53_record" "caa" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 3600
  records = [
    "0 issue \"${var.ca_allowed}\""
  ]
}

# Create weighted routing for "test" subdomain (A/B testing example)
resource "aws_route53_record" "test_a" {
  count          = var.create_weighted_records ? 1 : 0
  zone_id        = aws_route53_zone.main.zone_id
  name           = "test.${var.domain_name}"
  type           = "A"
  set_identifier = "version-a"

  weighted_routing_policy {
    weight = 80
  }

  ttl     = 300
  records = [var.test_ip_a]
}

resource "aws_route53_record" "test_b" {
  count          = var.create_weighted_records ? 1 : 0
  zone_id        = aws_route53_zone.main.zone_id
  name           = "test.${var.domain_name}"
  type           = "A"
  set_identifier = "version-b"

  weighted_routing_policy {
    weight = 20
  }

  ttl     = 300
  records = [var.test_ip_b]
}

# Alias record for S3 website bucket (if enabled)
resource "aws_route53_record" "s3_website" {
  count   = var.create_s3_website_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "static.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.s3_website_endpoint
    zone_id                = var.s3_website_hosted_zone_id
    evaluate_target_health = false
  }
}

# Alias record for CloudFront distribution (if enabled)
resource "aws_route53_record" "cloudfront" {
  count   = var.create_cloudfront_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "cdn.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# Create subdomain delegation to another hosted zone (if enabled)
resource "aws_route53_record" "subdomain_delegation" {
  count   = var.create_subdomain_delegation ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.delegated_subdomain}.${var.domain_name}"
  type    = "NS"
  ttl     = 172800
  records = var.delegated_nameservers
}
```

## Step-by-Step Explanation

### 1. Create the AWS Provider

```terraform
provider "aws" {
  region = var.region
}
```

This configures the AWS provider to work in the specified region.

### 2. Create a Route 53 Public Hosted Zone

```terraform
resource "aws_route53_zone" "main" {
  name    = var.domain_name
  comment = "Managed by Terraform - Route 53 Lab"

  tags = {
    Environment = "Lab"
    Name        = var.domain_name
    Project     = "Terraform-Labs"
  }
}
```

This creates a public hosted zone for your domain. The hosted zone is a container for all your DNS records and is the foundation of your DNS configuration. The tags help with organization and cost attribution.

### 3. Create a Health Check

```terraform
resource "aws_route53_health_check" "web_health_check" {
  fqdn              = var.web_endpoint
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30

  tags = {
    Name = "web-health-check"
  }
}
```

This health check monitors the web endpoint on port 80 using HTTP. It:
- Checks the root path "/"
- Requires 3 consecutive failures to mark as unhealthy
- Checks every 30 seconds
- The health check is used for failover routing policies

### 4. Create Basic DNS Records

#### Root Domain A Record

```terraform
resource "aws_route53_record" "root_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [var.web_ip]
}
```

This creates an A record for the root domain (example.com) pointing to your web server IP. The TTL (Time To Live) of 300 seconds tells DNS resolvers to cache this record for 5 minutes.

#### WWW Subdomain A Record 

```terraform
resource "aws_route53_record" "www_a" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.web_ip]
}
```

This creates an A record for the www subdomain (www.example.com) pointing to the same web server IP.

#### App Subdomain CNAME Record

```terraform
resource "aws_route53_record" "app_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [var.web_endpoint]
}
```

This creates a CNAME record for the app subdomain, pointing to a DNS name rather than an IP address. This is useful when the underlying IP address might change, such as with load balancers or EC2 instances.

### 5. Configure Failover Routing for API

#### Primary Record with Health Check

```terraform
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
```

This creates the primary A record for the api subdomain with failover routing. It:
- Uses a set_identifier to distinguish it from other records with the same name and type
- Associates the health check to monitor the endpoint health
- Configures it as the PRIMARY in the failover policy
- Points to the primary API IP address

#### Secondary Record for Failover

```terraform
resource "aws_route53_record" "api_a_secondary" {
  zone_id        = aws_route53_zone.main.zone_id
  name           = "api.${var.domain_name}"
  type           = "A"
  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

  ttl     = 300
  records = [var.api_secondary_ip]
}
```

This creates the secondary A record for the api subdomain. It:
- Uses a different set_identifier
- Configures it as the SECONDARY in the failover policy (used when primary is unhealthy)
- Points to the secondary API IP address
- Note: Secondary records don't have health checks as they're only used when primary fails

### 6. Create Email-Related Records (Conditional)

#### MX Records

```terraform
resource "aws_route53_record" "mx" {
  count   = var.create_mx_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = 3600
  records = [
    "1 ${var.mx_server_primary}",
    "5 ${var.mx_server_secondary}",
    "10 ${var.mx_server_tertiary}"
  ]
}
```

This conditionally creates MX (Mail Exchange) records for email delivery:
- Only created if `create_mx_record` is true
- The numbers (1, 5, 10) represent priority (lower numbers = higher priority)
- Higher TTL (3600 seconds = 1 hour) since mail server configurations rarely change

#### SPF Record

```terraform
resource "aws_route53_record" "spf" {
  count   = var.create_spf_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 3600
  records = ["v=spf1 include:${var.spf_include} ~all"]
}
```

This conditionally creates an SPF (Sender Policy Framework) record:
- Only created if `create_spf_record` is true
- Implemented as a TXT record
- Helps prevent email spoofing by defining authorized mail senders
- The `~all` means soft fail for senders not matching the policy

#### DKIM Record

```terraform
resource "aws_route53_record" "dkim" {
  count   = var.create_dkim_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.dkim_selector}._domainkey.${var.domain_name}"
  type    = "TXT"
  ttl     = 3600
  records = [var.dkim_value]
}
```

This conditionally creates a DKIM (DomainKeys Identified Mail) record:
- Only created if `create_dkim_record` is true
- Uses a special naming format with a selector and "_domainkey" prefix
- Contains a public key that mail receivers use to verify message authenticity

### 7. Configure Certificate Authority Authorization

```terraform
resource "aws_route53_record" "caa" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 3600
  records = [
    "0 issue \"${var.ca_allowed}\""
  ]
}
```

This creates a CAA record which specifies which Certificate Authorities are allowed to issue SSL/TLS certificates for your domain:
- The "0" indicates this is a mandatory flag that must be followed
- "issue" specifies which CA can issue certificates
- By default, it allows only Amazon's CA (amazonaws.com)

### 8. Configure Weighted Routing for A/B Testing

```terraform
resource "aws_route53_record" "test_a" {
  count          = var.create_weighted_records ? 1 : 0
  zone_id        = aws_route53_zone.main.zone_id
  name           = "test.${var.domain_name}"
  type           = "A"
  set_identifier = "version-a"

  weighted_routing_policy {
    weight = 80
  }

  ttl     = 300
  records = [var.test_ip_a]
}

resource "aws_route53_record" "test_b" {
  count          = var.create_weighted_records ? 1 : 0
  zone_id        = aws_route53_zone.main.zone_id
  name           = "test.${var.domain_name}"
  type           = "A"
  set_identifier = "version-b"

  weighted_routing_policy {
    weight = 20
  }

  ttl     = 300
  records = [var.test_ip_b]
}
```

This conditionally creates weighted records for the test subdomain:
- Only created if `create_weighted_records` is true
- Uses set_identifiers to distinguish between versions
- Distributes traffic:
  - 80% to version A (weight = 80)
  - 20% to version B (weight = 20)
- Useful for A/B testing or gradual deployment rollouts

### 9. Create Records for AWS Services

#### S3 Website Alias Record

```terraform
resource "aws_route53_record" "s3_website" {
  count   = var.create_s3_website_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "static.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.s3_website_endpoint
    zone_id                = var.s3_website_hosted_zone_id
    evaluate_target_health = false
  }
}
```

This conditionally creates an alias record for an S3 static website:
- Only created if `create_s3_website_record` is true
- Uses Route 53's alias functionality rather than standard DNS records
- Points to an S3 website endpoint using both the endpoint domain and zone ID
- Alias records don't have TTL and are always kept up-to-date by AWS

#### CloudFront Alias Record

```terraform
resource "aws_route53_record" "cloudfront" {
  count   = var.create_cloudfront_record ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "cdn.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
```

This conditionally creates an alias record for a CloudFront distribution:
- Only created if `create_cloudfront_record` is true
- Creates a cdn subdomain
- Points to a CloudFront distribution
- CloudFront's global zone ID is always Z2FDTNDATAQYW2

### 10. Configure Subdomain Delegation

```terraform
resource "aws_route53_record" "subdomain_delegation" {
  count   = var.create_subdomain_delegation ? 1 : 0
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.delegated_subdomain}.${var.domain_name}"
  type    = "NS"
  ttl     = 172800
  records = var.delegated_nameservers
}
```

This conditionally creates NS records to delegate a subdomain to another hosted zone:
- Only created if `create_subdomain_delegation` is true
- Creates NS records for the specified subdomain
- Points to the nameservers specified in `delegated_nameservers`
- Uses a long TTL (172800 seconds = 48 hours) as nameserver changes are rare

## Testing the Solution

To test that your configuration works as expected, you can:

1. Deploy the infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

2. Update your domain registrar with the Route 53 nameservers:
   - Log in to your domain registrar (GoDaddy, Namecheap, etc.)
   - Find the DNS/Nameserver settings
   - Replace existing nameservers with those from Terraform output
   - Save changes

3. Wait for DNS propagation (typically 15 minutes to 48 hours)

4. Verify the nameserver update:
   ```bash
   dig NS example.com +short
   ```

5. Test individual DNS records:
   ```bash
   # Test A record
   dig A example.com

   # Test CNAME record
   dig CNAME app.example.com

   # Test failover routing
   dig A api.example.com
   ```

6. Validate health check status:
   ```bash
   aws route53 get-health-check --health-check-id <health-check-id>
   ```

7. Clean up when done:
   ```bash
   terraform destroy
   ```

## Common Troubleshooting Tips

1. **DNS Propagation Delays**: After making changes, allow time for DNS propagation (typically minutes to hours).

2. **Nameserver Mismatch**: Ensure your domain's nameservers at the registrar exactly match the Route 53 nameservers.

3. **Health Check Failures**: Verify the endpoint is accessible from public internet and responds to HTTP requests.

4. **Alias Record Issues**: Make sure you're using the correct zone ID for the AWS service (S3, CloudFront).

5. **Record Set Conflicts**: You cannot have multiple records with the same name and type unless using routing policies with set_identifier.

6. **TTL Considerations**: Lower TTLs speed up propagation of changes but increase DNS query load; higher TTLs provide stability.

7. **Domain Registration vs. DNS Hosting**: Remember that Route 53 can host DNS separately from domain registration; you must update nameservers at your registrar.

## Additional Learning Resources

For more about Route 53 and DNS:

- [Route 53 Developer Guide](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
- [DNS for Developers](https://www.oreilly.com/library/view/dns-for-developers/9781098155124/)
- [AWS Well-Architected Framework: Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html) 