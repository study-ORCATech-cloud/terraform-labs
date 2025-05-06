# TODO: Configure the Azure Provider
# Requirements:
# - Set the features block
# - Use Azure Resource Manager (AzureRM)

provider "azurerm" {
  # TODO: Configure the features block with appropriate settings
  features {}
}

# TODO: Create a Resource Group for DNS resources
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create a DNS Zone
# Requirements:
# - Use azurerm_dns_zone resource
# - Set name using var.domain_name
# - Set zone_type to "Public" (or use var.zone_type)
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create A Record Set(s)
# Requirements:
# - Use azurerm_dns_a_record resource
# - Create A records for each entry in var.a_records
# - Set name and IP address(es) according to var.a_records configuration
# - Set ttl to var.default_ttl (or use the ttl from each record if specified)
# - Reference the DNS zone and resource group you created

# TODO: Create CNAME Record Set(s)
# Requirements:
# - Use azurerm_dns_cname_record resource
# - Create CNAME records for each entry in var.cname_records
# - Set name and target according to var.cname_records configuration
# - Set ttl to var.default_ttl (or use the ttl from each record if specified)
# - Reference the DNS zone and resource group you created

# TODO: Create TXT Record Set(s)
# Requirements:
# - Use azurerm_dns_txt_record resource
# - Create TXT records for each entry in var.txt_records
# - Set name and value according to var.txt_records configuration
# - Set ttl to var.default_ttl (or use the ttl from each record if specified)
# - Reference the DNS zone and resource group you created

# TODO (Optional): Create MX Record Set
# Requirements:
# - Use azurerm_dns_mx_record resource
# - Create MX records if var.mx_records is provided
# - Set each record with preference and exchange values
# - Set ttl to var.default_ttl (or use specified ttl)
# - Reference the DNS zone and resource group you created
# - Only create this resource if var.mx_records is not empty 
