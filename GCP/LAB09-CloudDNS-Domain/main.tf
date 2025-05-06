provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Enable the Cloud DNS API
# Requirements:
# - Use the google_project_service resource
# - Enable "dns.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Create a public DNS zone
# Requirements:
# - Use google_dns_managed_zone resource
# - Set name using var.dns_zone_name
# - Set dns_name using var.domain_name (don't forget the trailing dot)
# - Set visibility to "public"
# - Set an appropriate description
# - Apply labels from var.labels

# TODO: Add an A record to point to web server
# Requirements:
# - Use google_dns_record_set resource
# - Set name to include proper subdomain ("@" or "www") and domain
# - Set type to "A"
# - Set TTL from var.record_ttl
# - Add rrdatas array with IP address(es) from var.a_record_ip_addresses

# TODO: Add a CNAME record to create an alias
# Requirements:
# - Use google_dns_record_set resource
# - Set name to include the subdomain from var.cname_record_name
# - Set type to "CNAME"
# - Set TTL from var.record_ttl
# - Set rrdatas to the target domain from var.cname_record_target (with trailing dot)

# TODO: Add a TXT record for domain verification
# Requirements:
# - Use google_dns_record_set resource
# - Set name to the domain name
# - Set type to "TXT"
# - Set TTL from var.record_ttl
# - Add rrdatas with verification value from var.txt_record_value (in quotes)

# TODO: (Optional) Add an MX record for email
# Requirements:
# - Use google_dns_record_set resource 
# - Only create this record if var.create_mx_record is true
# - Set appropriate priority values for each mail server
# - Format entries as "<priority> <mail_server>"
# - Set appropriate TTL 
