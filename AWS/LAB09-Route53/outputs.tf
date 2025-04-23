output "hosted_zone_id" {
  description = "ID of the created Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Nameservers for the hosted zone (update these at your domain registrar)"
  value       = aws_route53_zone.main.name_servers
}

output "domain_name" {
  description = "Domain name for the hosted zone"
  value       = aws_route53_zone.main.name
}

output "root_a_record" {
  description = "Root domain A record configuration"
  value = {
    name  = aws_route53_record.root_a.name
    type  = aws_route53_record.root_a.type
    ttl   = aws_route53_record.root_a.ttl
    value = aws_route53_record.root_a.records[0]
  }
}

output "www_record" {
  description = "www subdomain record configuration"
  value = {
    name  = aws_route53_record.www_a.name
    type  = aws_route53_record.www_a.type
    ttl   = aws_route53_record.www_a.ttl
    value = aws_route53_record.www_a.records[0]
  }
}

output "app_record" {
  description = "app subdomain record configuration"
  value = {
    name  = aws_route53_record.app_cname.name
    type  = aws_route53_record.app_cname.type
    ttl   = aws_route53_record.app_cname.ttl
    value = aws_route53_record.app_cname.records[0]
  }
}

output "api_record_primary" {
  description = "api subdomain primary record configuration"
  value = {
    name            = aws_route53_record.api_a.name
    type            = aws_route53_record.api_a.type
    routing_policy  = "failover (primary)"
    value           = aws_route53_record.api_a.records[0]
    health_check_id = aws_route53_record.api_a.health_check_id
  }
}

output "api_record_secondary" {
  description = "api subdomain secondary record configuration"
  value = {
    name           = aws_route53_record.api_a_secondary.name
    type           = aws_route53_record.api_a_secondary.type
    routing_policy = "failover (secondary)"
    value          = aws_route53_record.api_a_secondary.records[0]
  }
}

output "health_check_id" {
  description = "ID of the created health check"
  value       = aws_route53_health_check.web_health_check.id
}

output "health_check_status" {
  description = "Status of the health check"
  value       = "Check AWS Console for current status"
}

output "dns_propagation_check_command" {
  description = "Command to check DNS propagation"
  value       = "dig NS ${var.domain_name} +short"
}

output "registrar_update_instructions" {
  description = "Instructions to update nameservers at your domain registrar"
  value       = <<-EOT
    1. Log in to your domain registrar account (where you purchased your domain)
    2. Find the DNS or Nameserver settings for ${var.domain_name}
    3. Replace the existing nameservers with the following AWS nameservers:
       ${join("\n       ", aws_route53_zone.main.name_servers)}
    4. Save the changes
    5. Wait for DNS propagation (can take up to 48 hours)
    6. Verify with: dig NS ${var.domain_name} +short
  EOT
}

output "created_records" {
  description = "Summary of created DNS records"
  value = {
    a_records = [
      "root (${var.domain_name})",
      "www.${var.domain_name}",
      "api.${var.domain_name} (primary and secondary)"
    ]
    cname_records = [
      "app.${var.domain_name}"
    ]
    mx_records = var.create_mx_record ? ["${var.domain_name} (MX)"] : []
    txt_records = concat(
      var.create_spf_record ? ["${var.domain_name} (SPF)"] : [],
      var.create_dkim_record ? ["${var.dkim_selector}._domainkey.${var.domain_name} (DKIM)"] : []
    )
    caa_records      = ["${var.domain_name} (CAA)"]
    weighted_records = var.create_weighted_records ? ["test.${var.domain_name} (version A: 80%, version B: 20%)"] : []
    alias_records = concat(
      var.create_s3_website_record ? ["static.${var.domain_name} (S3 Website)"] : [],
      var.create_cloudfront_record ? ["cdn.${var.domain_name} (CloudFront)"] : []
    )
    delegated_records = var.create_subdomain_delegation ? ["${var.delegated_subdomain}.${var.domain_name} (NS delegation)"] : []
  }
}

output "aws_cli_check_health" {
  description = "AWS CLI command to check health check status"
  value       = "aws route53 get-health-check --health-check-id ${aws_route53_health_check.web_health_check.id} --region ${var.region}"
}

output "aws_cli_list_records" {
  description = "AWS CLI command to list all records in the hosted zone"
  value       = "aws route53 list-resource-record-sets --hosted-zone-id ${aws_route53_zone.main.zone_id} --region ${var.region}"
} 
