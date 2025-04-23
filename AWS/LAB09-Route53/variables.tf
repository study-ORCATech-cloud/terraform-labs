variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "domain_name" {
  description = "The domain name to configure in Route 53"
  type        = string
  default     = "example.com" # Change this to your domain
}

variable "web_ip" {
  description = "IP address for the web server (A records)"
  type        = string
  default     = "203.0.113.10" # Example IP - replace with your web server IP
}

variable "web_endpoint" {
  description = "Endpoint for the web server (CNAME records)"
  type        = string
  default     = "ec2-instance.eu-west-1.compute.amazonaws.com" # Example - replace with your endpoint
}

variable "api_primary_ip" {
  description = "Primary IP address for the API endpoint"
  type        = string
  default     = "203.0.113.20" # Example IP - replace with your primary API IP
}

variable "api_secondary_ip" {
  description = "Secondary IP address for the API endpoint (failover)"
  type        = string
  default     = "203.0.113.21" # Example IP - replace with your secondary API IP
}

variable "create_mx_record" {
  description = "Whether to create MX records for email"
  type        = bool
  default     = false
}

variable "mx_server_primary" {
  description = "Primary mail server hostname"
  type        = string
  default     = "aspmx.l.google.com" # Example for Google Workspace
}

variable "mx_server_secondary" {
  description = "Secondary mail server hostname"
  type        = string
  default     = "alt1.aspmx.l.google.com" # Example for Google Workspace
}

variable "mx_server_tertiary" {
  description = "Tertiary mail server hostname"
  type        = string
  default     = "alt2.aspmx.l.google.com" # Example for Google Workspace
}

variable "create_spf_record" {
  description = "Whether to create SPF record for email"
  type        = bool
  default     = false
}

variable "spf_include" {
  description = "Domain to include in SPF record"
  type        = string
  default     = "_spf.google.com" # Example for Google Workspace
}

variable "create_dkim_record" {
  description = "Whether to create DKIM record for email"
  type        = bool
  default     = false
}

variable "dkim_selector" {
  description = "DKIM selector for email authentication"
  type        = string
  default     = "google" # Example for Google Workspace
}

variable "dkim_value" {
  description = "DKIM TXT record value"
  type        = string
  default     = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxyz" # Example - replace with actual DKIM key
}

variable "ca_allowed" {
  description = "Allowed Certificate Authority for SSL certificates"
  type        = string
  default     = "amazonaws.com" # Allows Amazon's CA to issue certs
}

variable "create_weighted_records" {
  description = "Whether to create weighted records for A/B testing"
  type        = bool
  default     = false
}

variable "test_ip_a" {
  description = "IP address for version A of test endpoint"
  type        = string
  default     = "203.0.113.30" # Example IP - replace with actual test IP
}

variable "test_ip_b" {
  description = "IP address for version B of test endpoint"
  type        = string
  default     = "203.0.113.31" # Example IP - replace with actual test IP
}

variable "create_s3_website_record" {
  description = "Whether to create a record for an S3 website"
  type        = bool
  default     = false
}

variable "s3_website_endpoint" {
  description = "S3 website endpoint"
  type        = string
  default     = "s3-website.eu-west-1.amazonaws.com" # This is just an example
}

variable "s3_website_hosted_zone_id" {
  description = "Hosted zone ID for the S3 website endpoint"
  type        = string
  default     = "Z1BKCTXD74EZPE" # eu-west-1 S3 website zone ID
}

variable "create_cloudfront_record" {
  description = "Whether to create a record for a CloudFront distribution"
  type        = bool
  default     = false
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
  default     = "d1234abcdef.cloudfront.net" # Example - replace with actual distribution domain
}

variable "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID for CloudFront"
  type        = string
  default     = "Z2FDTNDATAQYW2" # CloudFront hosted zone ID (global)
}

variable "create_subdomain_delegation" {
  description = "Whether to delegate a subdomain to another hosted zone"
  type        = bool
  default     = false
}

variable "delegated_subdomain" {
  description = "Subdomain to delegate"
  type        = string
  default     = "dev" # Example subdomain
}

variable "delegated_nameservers" {
  description = "Nameservers for the delegated subdomain"
  type        = list(string)
  default = [
    "ns-1.awsdns-00.org",
    "ns-2.awsdns-11.com",
    "ns-3.awsdns-22.co.uk",
    "ns-4.awsdns-33.net"
  ] # Example - replace with actual nameservers
} 
