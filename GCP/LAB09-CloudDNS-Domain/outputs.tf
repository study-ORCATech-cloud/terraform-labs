# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "dns_zone_name" {
  description = "Name of the DNS zone"
  value       = google_dns_managed_zone.dns_zone.name
}

output "dns_zone_name_servers" {
  description = "List of name servers for the DNS zone (use these to delegate your domain)"
  value       = google_dns_managed_zone.dns_zone.name_servers
}

output "domain_name" {
  description = "Domain name configured in the DNS zone"
  value       = trimsuffix(google_dns_managed_zone.dns_zone.dns_name, ".")
}

output "a_record_name" {
  description = "DNS name for the A record"
  value       = google_dns_record_set.a_record.name
}

output "a_record_ips" {
  description = "IP addresses for the A record"
  value       = google_dns_record_set.a_record.rrdatas
}

output "cname_record_name" {
  description = "DNS name for the CNAME record"
  value       = google_dns_record_set.cname_record.name
}

output "cname_record_target" {
  description = "Target for the CNAME record"
  value       = google_dns_record_set.cname_record.rrdatas[0]
}

output "txt_record_name" {
  description = "DNS name for the TXT record"
  value       = google_dns_record_set.txt_record.name
}

output "txt_record_value" {
  description = "Value of the TXT record"
  value       = google_dns_record_set.txt_record.rrdatas[0]
}

output "mx_record_name" {
  description = "DNS name for the MX record (if created)"
  value       = var.create_mx_record ? google_dns_record_set.mx_record[0].name : "MX record not created"
}

output "mx_record_values" {
  description = "Mail servers for the MX record (if created)"
  value       = var.create_mx_record ? google_dns_record_set.mx_record[0].rrdatas : ["MX record not created"]
}

output "nameserver_instructions" {
  description = "Instructions for updating nameservers at your domain registrar"
  value       = <<-EOT
    To delegate your domain to Google Cloud DNS, update your domain's nameservers at your registrar to:
    
    ${join("\n    ", google_dns_managed_zone.dns_zone.name_servers)}
    
    This change may take 24-48 hours to propagate globally.
  EOT
}

output "dns_verification_command" {
  description = "Command to verify DNS delegation"
  value       = "nslookup -type=NS ${trimsuffix(google_dns_managed_zone.dns_zone.dns_name, ".")}"
}

output "a_record_verification_command" {
  description = "Command to verify A record"
  value       = "nslookup ${trimsuffix(google_dns_record_set.a_record.name, ".")}"
}

output "txt_record_verification_command" {
  description = "Command to verify TXT record"
  value       = "nslookup -type=TXT ${trimsuffix(google_dns_record_set.txt_record.name, ".")}"
}

output "console_url" {
  description = "URL to access the DNS zone in the Cloud Console"
  value       = "https://console.cloud.google.com/net-services/dns/zones/details/${google_dns_managed_zone.dns_zone.name}?project=${var.project_id}"
} 
