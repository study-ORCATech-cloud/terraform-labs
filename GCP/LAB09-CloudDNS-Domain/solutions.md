# LAB09: Cloud DNS and Custom Domain Solutions

This document provides solutions for the Cloud DNS and Custom Domain lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable the Cloud DNS API
resource "google_project_service" "dns_api" {
  service                    = "dns.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Create a public DNS zone
resource "google_dns_managed_zone" "dns_zone" {
  name        = var.dns_zone_name
  dns_name    = "${var.domain_name}."
  description = "Public DNS zone for ${var.domain_name}"
  visibility  = "public"
  labels      = var.labels

  depends_on = [google_project_service.dns_api]
}

# Add an A record to point to web server
resource "google_dns_record_set" "a_record" {
  name         = "${var.domain_name}."
  type         = "A"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = var.a_record_ip_addresses
}

# Add a www A record (common practice)
resource "google_dns_record_set" "www_a_record" {
  name         = "www.${var.domain_name}."
  type         = "A"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = var.a_record_ip_addresses
}

# Add a CNAME record to create an alias
resource "google_dns_record_set" "cname_record" {
  name         = "${var.cname_record_name}.${var.domain_name}."
  type         = "CNAME"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = [var.cname_record_target]
}

# Add a TXT record for domain verification
resource "google_dns_record_set" "txt_record" {
  name         = "${var.domain_name}."
  type         = "TXT"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = ["\"${var.txt_record_value}\""]
}

# Add an MX record for email (if enabled)
resource "google_dns_record_set" "mx_record" {
  count = var.create_mx_record ? 1 : 0

  name         = "${var.domain_name}."
  type         = "MX"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  
  rrdatas = [
    for server in var.mx_record_mail_servers :
    "${server.priority} ${server.mail_server}"
  ]
}

# Add an SPF record for email validation (if enabled)
resource "google_dns_record_set" "spf_record" {
  count = var.create_spf_record ? 1 : 0

  name         = "${var.domain_name}."
  type         = "TXT"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = ["\"${var.spf_record_value}\""]
}
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}
```

This configures the Google Cloud provider with your project ID and region. Using variables allows flexibility across different environments.

### 2. Enable Required API

```terraform
resource "google_project_service" "dns_api" {
  service                    = "dns.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}
```

This enables the Cloud DNS API which is required to create and manage DNS zones and records. The resource:
- Specifies the API service to enable
- Sets `disable_on_destroy` to true to disable the API when you run `terraform destroy`
- Sets custom timeouts to allow for API activation, which can take time
- Disables dependent services when destroying to prevent orphaned resources

### 3. Create a Public DNS Zone

```terraform
resource "google_dns_managed_zone" "dns_zone" {
  name        = var.dns_zone_name
  dns_name    = "${var.domain_name}."
  description = "Public DNS zone for ${var.domain_name}"
  visibility  = "public"
  labels      = var.labels

  depends_on = [google_project_service.dns_api]
}
```

This creates a public DNS zone for your domain:
- Sets a name for the zone (alphanumeric with hyphens)
- Sets the DNS name with a trailing dot (required in DNS notation)
- Adds a description for better identification
- Sets visibility to "public" to make it internet-accessible
- Applies labels for resource organization
- Depends on the DNS API being enabled

### 4. Add A Records for Root and WWW

```terraform
resource "google_dns_record_set" "a_record" {
  name         = "${var.domain_name}."
  type         = "A"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = var.a_record_ip_addresses
}

resource "google_dns_record_set" "www_a_record" {
  name         = "www.${var.domain_name}."
  type         = "A"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = var.a_record_ip_addresses
}
```

These create A records that map your domain and its www subdomain to IP addresses:
- The first record maps the root domain (example.com) to the IP addresses
- The second record maps the www subdomain (www.example.com) to the same IP addresses
- Both use the same TTL (Time To Live) value to control caching behavior
- Each record belongs to the managed zone we created

### 5. Add a CNAME Record for a Subdomain

```terraform
resource "google_dns_record_set" "cname_record" {
  name         = "${var.cname_record_name}.${var.domain_name}."
  type         = "CNAME"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = [var.cname_record_target]
}
```

This creates a CNAME record that acts as an alias pointing to another domain:
- Uses the subdomain name from variables (e.g., "app" to create app.example.com)
- Sets the record type to "CNAME"
- Points to the target domain (with a trailing dot)
- Often used for services that provide their own hostnames (like Cloud Run or App Engine)

### 6. Add a TXT Record for Domain Verification

```terraform
resource "google_dns_record_set" "txt_record" {
  name         = "${var.domain_name}."
  type         = "TXT"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = ["\"${var.txt_record_value}\""]
}
```

This creates a TXT record often used for domain verification:
- TXT records hold arbitrary text and are used for various verification purposes
- The value is wrapped in quotes as required by the DNS protocol
- Often used for Google Search Console, domain verification, or SPF records

### 7. Add Optional MX and SPF Records

```terraform
resource "google_dns_record_set" "mx_record" {
  count = var.create_mx_record ? 1 : 0

  name         = "${var.domain_name}."
  type         = "MX"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  
  rrdatas = [
    for server in var.mx_record_mail_servers :
    "${server.priority} ${server.mail_server}"
  ]
}

resource "google_dns_record_set" "spf_record" {
  count = var.create_spf_record ? 1 : 0

  name         = "${var.domain_name}."
  type         = "TXT"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = ["\"${var.spf_record_value}\""]
}
```

These conditionally create email-related records:
- The MX record uses a count parameter to only create the record if requested
- MX records specify mail servers and their priorities for email delivery
- The SPF record is actually another TXT record with a specific format
- SPF (Sender Policy Framework) helps prevent email spoofing by specifying which servers are allowed to send mail from your domain

## Variables and Outputs

### Important Variables

- **domain_name**: The actual domain you're configuring (without trailing dot)
- **dns_zone_name**: An identifier for the zone in Cloud DNS
- **a_record_ip_addresses**: IP addresses for your domain and www subdomain
- **record_ttl**: Controls how long DNS resolvers cache records

### Key Outputs

- **dns_zone_name_servers**: The list of Google name servers to configure at your domain registrar
- **nameserver_instructions**: Formatted instructions for updating nameservers
- **verification_commands**: Commands to test your DNS setup
- **console_url**: Direct link to the DNS zone in Cloud Console

## Domain Delegation Process

After applying the Terraform configuration, you'll need to:

1. Get the name servers from the `dns_zone_name_servers` output
2. Log in to your domain registrar (e.g., Namecheap, GoDaddy)
3. Find the nameserver settings for your domain
4. Replace the current nameservers with Google's name servers
5. Wait 24-48 hours for DNS changes to propagate globally
6. Verify using the provided verification commands

## Common Issues and Solutions

1. **Missing trailing dots**: Always include trailing dots in DNS names and CNAME targets
2. **Quotes in TXT records**: TXT record values should be wrapped in quotes
3. **Propagation delay**: DNS changes can take 24-48 hours to fully propagate
4. **Multiple TXT records**: Be careful when adding multiple TXT records for the same name

## Advanced Customizations

For more complex deployments, consider:

1. Creating private DNS zones for internal use:
```terraform
resource "google_dns_managed_zone" "private_zone" {
  name        = "internal-zone"
  dns_name    = "internal.example.com."
  description = "Private DNS zone"
  visibility  = "private"
  
  private_visibility_config {
    networks {
      network_url = "projects/${var.project_id}/global/networks/default"
    }
  }
}
```

2. Setting up DNS forwarding to other DNS servers:
```terraform
resource "google_dns_managed_zone" "forwarding_zone" {
  name        = "forwarding-zone"
  dns_name    = "forwarded.example.com."
  description = "Forwarding DNS zone"
  visibility  = "private"
  
  forwarding_config {
    target_name_servers {
      ipv4_address = "10.0.0.1"
    }
  }
  
  private_visibility_config {
    networks {
      network_url = "projects/${var.project_id}/global/networks/default"
    }
  }
}
```

3. Creating DKIM records for email authentication:
```terraform
resource "google_dns_record_set" "dkim_record" {
  name         = "selector._domainkey.${var.domain_name}."
  type         = "TXT"
  ttl          = var.record_ttl
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = ["\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9...\""]
}
``` 