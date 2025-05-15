# TODO: Create a Route 53 public hosted zone for the domain
# Requirements:
# - Use the domain name from var.domain_name
# - Add a comment about it being managed by Terraform
# - Add appropriate tags (Environment, Name, Project)

# TODO: Create a health check for the web server
# Requirements:
# - Target the web endpoint using var.web_endpoint
# - Configure it for HTTP on port 80
# - Check the root path "/"
# - Set failure_threshold to 3
# - Set request_interval to 30 seconds
# - Add a Name tag

# TODO: Create an A record for the root domain
# Requirements:
# - Point it to the web IP using var.web_ip
# - Set an appropriate TTL (300 seconds recommended)
# - Use the zone_id from your hosted zone

# TODO: Create an A record for the "www" subdomain
# Requirements:
# - Point it to the same web IP using var.web_ip
# - Set the same TTL as the root domain record
# - Remember to construct the full subdomain name using the domain name

# TODO: Create a CNAME record for "app" subdomain
# Requirements:
# - Point it to the web endpoint using var.web_endpoint
# - Use a TTL of 300 seconds
# - Remember that CNAME records point to another domain, not an IP

# TODO: Create a health-checked A record for "api" subdomain as primary
# Requirements:
# - Configure it with failover routing policy as PRIMARY
# - Associate it with the health check you created above
# - Set an appropriate TTL
# - Point to var.api_primary_ip
# - Use a set_identifier to distinguish it from the secondary record

# TODO: Create a secondary failover record for "api" subdomain
# Requirements:
# - Configure it with failover routing policy as SECONDARY
# - Set the same TTL as the primary record
# - Point to var.api_secondary_ip
# - Use a different set_identifier than the primary record
# - No health check is needed for secondary records

# TODO: Create MX records for email (if enabled)
# Requirements:
# - Only create this if var.create_mx_record is true (use count)
# - Use TTL of 3600 seconds (1 hour)
# - Add three priority mail servers with priorities 1, 5, and 10
# - Use var.mx_server_primary, var.mx_server_secondary, and var.mx_server_tertiary

# TODO: Create TXT record for SPF (Sender Policy Framework)
# Requirements:
# - Only create this if var.create_spf_record is true (use count)
# - Set TTL to 3600 seconds
# - Use the format "v=spf1 include:${var.spf_include} ~all"

# TODO: Create DKIM record for email authentication
# Requirements:
# - Only create this if var.create_dkim_record is true (use count)
# - Use a special name format: "${var.dkim_selector}._domainkey.${var.domain_name}"
# - Set TTL to 3600 seconds
# - Use var.dkim_value for the record value

# TODO: Create CAA (Certificate Authority Authorization) record
# Requirements:
# - Allow only the specified CA from var.ca_allowed to issue certificates
# - Set TTL to 3600 seconds
# - Use the format "0 issue \"${var.ca_allowed}\""

# TODO: Create weighted routing for "test" subdomain (version A)
# Requirements:
# - Only create this if var.create_weighted_records is true (use count)
# - Configure it with a weight of 80 (80% of traffic)
# - Set TTL to 300 seconds
# - Point to var.test_ip_a
# - Use "version-a" as the set_identifier

# TODO: Create weighted routing for "test" subdomain (version B)
# Requirements:
# - Only create this if var.create_weighted_records is true (use count)
# - Configure it with a weight of 20 (20% of traffic)
# - Set TTL to 300 seconds
# - Point to var.test_ip_b
# - Use "version-b" as the set_identifier

# TODO: Create an alias record for an S3 website
# Requirements:
# - Only create this if var.create_s3_website_record is true (use count)
# - Create a "static" subdomain
# - Configure an alias pointing to var.s3_website_endpoint
# - Use var.s3_website_hosted_zone_id for the zone_id in the alias configuration
# - Set evaluate_target_health to false

# TODO: Create an alias record for a CloudFront distribution
# Requirements:
# - Only create this if var.create_cloudfront_record is true (use count)
# - Create a "cdn" subdomain
# - Configure an alias pointing to var.cloudfront_domain_name
# - Use var.cloudfront_hosted_zone_id for the zone_id
# - Set evaluate_target_health to false

# TODO: Create subdomain delegation to another hosted zone
# Requirements:
# - Only create this if var.create_subdomain_delegation is true (use count)
# - Use NS record type
# - Set TTL to 172800 seconds (48 hours)
# - Use "${var.delegated_subdomain}.${var.domain_name}" for the name
# - Use var.delegated_nameservers for the list of nameservers
