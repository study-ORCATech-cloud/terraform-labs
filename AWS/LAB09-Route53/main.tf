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
