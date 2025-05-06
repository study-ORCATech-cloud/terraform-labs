# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.dns_rg.name
}

output "dns_zone_name" {
  description = "Name of the DNS zone"
  value       = azurerm_dns_zone.domain.name
}

output "dns_zone_id" {
  description = "ID of the DNS zone"
  value       = azurerm_dns_zone.domain.id
}

output "nameservers" {
  description = "List of name servers for the DNS zone (update your domain registrar with these)"
  value       = azurerm_dns_zone.domain.name_servers
}

output "a_records" {
  description = "List of A records created"
  value = [for record in azurerm_dns_a_record.records : {
    fqdn    = record.fqdn
    ttl     = record.ttl
    records = record.records
  }]
}

output "cname_records" {
  description = "List of CNAME records created"
  value = [for record in azurerm_dns_cname_record.records : {
    fqdn   = record.fqdn
    ttl    = record.ttl
    record = record.record
  }]
}

output "txt_records" {
  description = "List of TXT records created"
  value = [for record in azurerm_dns_txt_record.records : {
    fqdn    = record.fqdn
    ttl     = record.ttl
    records = record.record
  }]
}

output "mx_records" {
  description = "List of MX records created"
  value = try([for record in azurerm_dns_mx_record.records : {
    fqdn       = record.fqdn
    ttl        = record.ttl
    preference = record.record.*.preference
    exchange   = record.record.*.exchange
  }], "No MX records created")
}

output "registrar_update_instructions" {
  description = "Instructions to update your domain registrar"
  value       = <<-EOT
    To complete the DNS setup, you need to update your domain registrar with the Azure nameservers:
    
    1. Log in to your domain registrar's website (e.g., GoDaddy, Namecheap, etc.)
    2. Find the DNS or nameserver settings for your domain
    3. Replace the existing nameservers with Azure's nameservers:
       ${join("\n       ", azurerm_dns_zone.domain.name_servers)}
    
    Note: DNS propagation can take 24-48 hours to complete globally.
    
    To verify your configuration:
    - Run: nslookup -type=NS ${azurerm_dns_zone.domain.name}
    - Expected result should show Azure nameservers
  EOT
}

output "dns_queries" {
  description = "Sample DNS queries to test your configuration"
  value       = <<-EOT
    # Test A record for root domain:
    nslookup ${azurerm_dns_zone.domain.name}
    
    # Test A record for www:
    nslookup www.${azurerm_dns_zone.domain.name}
    
    # Test CNAME record:
    nslookup blog.${azurerm_dns_zone.domain.name}
    
    # Test MX records:
    nslookup -type=MX ${azurerm_dns_zone.domain.name}
    
    # Test TXT records:
    nslookup -type=TXT ${azurerm_dns_zone.domain.name}
  EOT
}

output "azure_portal_url" {
  description = "Azure portal URL to view the DNS zone"
  value       = "https://portal.azure.com/#resource${azurerm_dns_zone.domain.id}/overview"
}
