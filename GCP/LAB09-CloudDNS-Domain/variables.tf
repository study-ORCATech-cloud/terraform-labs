variable "project_id" {
  description = "The Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "domain_name" {
  description = "The domain name to configure (e.g., example.com)"
  type        = string
}

variable "dns_zone_name" {
  description = "Name for the DNS zone (alphanumeric with hyphens)"
  type        = string
  default     = "my-dns-zone"
}

variable "record_ttl" {
  description = "TTL (Time To Live) for DNS records in seconds"
  type        = number
  default     = 300 # 5 minutes
}

variable "a_record_ip_addresses" {
  description = "List of IP addresses for the A record"
  type        = list(string)
  default     = ["203.0.113.10"] # Example IP, replace with actual IP
}

variable "cname_record_name" {
  description = "Subdomain name for the CNAME record (e.g., 'app' for app.example.com)"
  type        = string
  default     = "app"
}

variable "cname_record_target" {
  description = "Target domain for the CNAME record (e.g., 'ghs.googlehosted.com')"
  type        = string
  default     = "ghs.googlehosted.com."
}

variable "txt_record_value" {
  description = "Value for the TXT record (e.g., for domain verification)"
  type        = string
  default     = "google-site-verification=example123456"
}

variable "create_mx_record" {
  description = "Whether to create an MX record for email"
  type        = bool
  default     = false
}

variable "mx_record_mail_servers" {
  description = "List of mail servers with priorities for MX record"
  type = list(object({
    priority    = number
    mail_server = string
  }))
  default = [
    {
      priority    = 1
      mail_server = "aspmx.l.google.com."
    },
    {
      priority    = 5
      mail_server = "alt1.aspmx.l.google.com."
    },
    {
      priority    = 5
      mail_server = "alt2.aspmx.l.google.com."
    },
    {
      priority    = 10
      mail_server = "alt3.aspmx.l.google.com."
    },
    {
      priority    = 10
      mail_server = "alt4.aspmx.l.google.com."
    }
  ]
}

variable "create_spf_record" {
  description = "Whether to create an SPF record for email validation"
  type        = bool
  default     = false
}

variable "spf_record_value" {
  description = "Value for the SPF record"
  type        = string
  default     = "v=spf1 include:_spf.google.com ~all"
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default = {
    environment = "dev"
    managed_by  = "terraform"
    project     = "terraform-labs"
  }
} 
