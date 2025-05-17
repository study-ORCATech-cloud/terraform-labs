# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

# TODO: Define an output for hosted_zone_id
# Requirements:
# - Name it "hosted_zone_id"
# - Description should be "ID of the created Route 53 hosted zone"
# - Value should be the zone_id of the hosted zone you created
# HINT: Use aws_route53_zone.main.zone_id

# TODO: Define an output for name_servers
# Requirements:
# - Name it "name_servers"
# - Description should be "Nameservers for the hosted zone (update these at your domain registrar)"
# - Value should be the list of name servers for the hosted zone
# HINT: Use aws_route53_zone.main.name_servers

# TODO: Define an output for domain_name
# Requirements:
# - Name it "domain_name"
# - Description should be "Domain name for the hosted zone"
# - Value should be the name of the hosted zone
# HINT: Use aws_route53_zone.main.name

# TODO: Define an output for root_a_record
# Requirements:
# - Name it "root_a_record"
# - Description should be "Root domain A record configuration"
# - Value should be an object with name, type, ttl, and the IP value from the A record
# HINT: Use a map with aws_route53_record.root_a properties

# TODO: Define an output for www_record
# Requirements:
# - Name it "www_record"
# - Description should be "www subdomain record configuration"
# - Value should be an object with name, type, ttl, and the IP value from the A record
# HINT: Use a map with aws_route53_record.www_a properties

# TODO: Define an output for app_record
# Requirements:
# - Name it "app_record"
# - Description should be "app subdomain record configuration"
# - Value should be an object with name, type, ttl, and the CNAME value
# HINT: Use a map with aws_route53_record.app_cname properties

# TODO: Define an output for api_record_primary
# Requirements:
# - Name it "api_record_primary"
# - Description should be "api subdomain primary record configuration"
# - Value should be an object with name, type, routing policy, IP value, and health check ID
# HINT: Use a map with aws_route53_record.api_a properties

# TODO: Define an output for api_record_secondary
# Requirements:
# - Name it "api_record_secondary"
# - Description should be "api subdomain secondary record configuration"
# - Value should be an object with name, type, routing policy, and IP value
# HINT: Use a map with aws_route53_record.api_a_secondary properties

# TODO: Define an output for health_check_id
# Requirements:
# - Name it "health_check_id"
# - Description should be "ID of the created health check"
# - Value should be the ID of the health check
# HINT: Use aws_route53_health_check.web_health_check.id

# TODO: Define an output for health_check_status
# Requirements:
# - Name it "health_check_status"
# - Description should be "Status of the health check"
# - Value should be a message to check AWS Console for current status
# HINT: Use a static string like "Check AWS Console for current status"

# TODO: Define an output for dns_propagation_check_command
# Requirements:
# - Name it "dns_propagation_check_command"
# - Description should be "Command to check DNS propagation"
# - Value should be a dig command for the domain's NS records
# HINT: Use "dig NS ${var.domain_name} +short"

# TODO: Define an output for registrar_update_instructions
# Requirements:
# - Name it "registrar_update_instructions"
# - Description should be "Instructions to update nameservers at your domain registrar"
# - Value should be a multi-line string with step-by-step instructions
# HINT: Use a heredoc string with steps to update nameservers

# TODO: Define an output for created_records
# Requirements:
# - Name it "created_records"
# - Description should be "Summary of created DNS records"
# - Value should be a map of record types and their values
# HINT: Use a map with lists of created record names by type

# TODO: Define an output for aws_cli_check_health
# Requirements:
# - Name it "aws_cli_check_health"
# - Description should be "AWS CLI command to check health check status"
# - Value should be an AWS CLI command to get health check status
# HINT: Use "aws route53 get-health-check --health-check-id ${aws_route53_health_check.web_health_check.id} --region ${var.region}"

# TODO: Define an output for aws_cli_list_records
# Requirements:
# - Name it "aws_cli_list_records"
# - Description should be "AWS CLI command to list all records in the hosted zone"
# - Value should be an AWS CLI command to list resource record sets
# HINT: Use "aws route53 list-resource-record-sets --hosted-zone-id ${aws_route53_zone.main.zone_id} --region ${var.region}"
