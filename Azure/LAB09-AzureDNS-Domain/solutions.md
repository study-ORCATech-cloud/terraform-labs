# LAB09: Azure DNS Domain and Custom Domain Solution

This document provides solutions for the Azure DNS Domain lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group for DNS resources
resource "azurerm_resource_group" "dns_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a DNS Zone
resource "azurerm_dns_zone" "domain" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.dns_rg.name
  zone_type           = var.zone_type
  
  tags = var.tags
}

# Create A Record Set(s)
resource "azurerm_dns_a_record" "records" {
  for_each            = { for idx, record in var.a_records : record.name => record }
  name                = each.value.name
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = each.value.ttl != null ? each.value.ttl : var.default_ttl
  records             = each.value.records
}

# Create CNAME Record Set(s)
resource "azurerm_dns_cname_record" "records" {
  for_each            = { for idx, record in var.cname_records : record.name => record }
  name                = each.value.name
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = each.value.ttl != null ? each.value.ttl : var.default_ttl
  record              = each.value.record
}

# Create TXT Record Set(s)
resource "azurerm_dns_txt_record" "records" {
  for_each            = { for idx, record in var.txt_records : record.name => record }
  name                = each.value.name
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = each.value.ttl != null ? each.value.ttl : var.default_ttl
  
  dynamic "record" {
    for_each = each.value.records
    content {
      value = record.value
    }
  }
}

# Create MX Record Set (Optional)
resource "azurerm_dns_mx_record" "records" {
  count               = length(var.mx_records) > 0 ? 1 : 0
  name                = "@"
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = var.default_ttl
  
  dynamic "record" {
    for_each = var.mx_records
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Provider

```terraform
provider "azurerm" {
  features {}
}
```

This configures the Azure Resource Manager provider. The empty `features {}` block is required by the provider.

### 2. Create a Resource Group

```terraform
resource "azurerm_resource_group" "dns_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for all the DNS resources in this lab.

### 3. Create a DNS Zone

```terraform
resource "azurerm_dns_zone" "domain" {
  name                = var.domain_name
  resource_group_name = azurerm_resource_group.dns_rg.name
  zone_type           = var.zone_type
  
  tags = var.tags
}
```

This creates a DNS zone for the specified domain name. A DNS zone is a container for all the DNS records for a specific domain. The `zone_type` parameter distinguishes between public and private DNS zones.

### 4. Create A Record Sets

```terraform
resource "azurerm_dns_a_record" "records" {
  for_each            = { for idx, record in var.a_records : record.name => record }
  name                = each.value.name
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = each.value.ttl != null ? each.value.ttl : var.default_ttl
  records             = each.value.records
}
```

This creates A records which map hostnames to IPv4 addresses. Key points:
- Uses `for_each` to create multiple A records from the `a_records` variable
- Each record includes a name (hostname), TTL (time-to-live), and one or more IPv4 addresses
- If a specific TTL isn't provided for a record, it uses the default TTL

### 5. Create CNAME Record Sets

```terraform
resource "azurerm_dns_cname_record" "records" {
  for_each            = { for idx, record in var.cname_records : record.name => record }
  name                = each.value.name
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = each.value.ttl != null ? each.value.ttl : var.default_ttl
  record              = each.value.record
}
```

This creates CNAME records which map one domain name to another (aliases). CNAME records are used for creating domain aliases or using services that require domain validation.

### 6. Create TXT Record Sets

```terraform
resource "azurerm_dns_txt_record" "records" {
  for_each            = { for idx, record in var.txt_records : record.name => record }
  name                = each.value.name
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = each.value.ttl != null ? each.value.ttl : var.default_ttl
  
  dynamic "record" {
    for_each = each.value.records
    content {
      value = record.value
    }
  }
}
```

This creates TXT records which store text data in the DNS. TXT records are often used for domain verification, SPF (Sender Policy Framework) records, DKIM (DomainKeys Identified Mail) records, and other domain validation purposes.

### 7. Create MX Record Set (Optional)

```terraform
resource "azurerm_dns_mx_record" "records" {
  count               = length(var.mx_records) > 0 ? 1 : 0
  name                = "@"
  zone_name           = azurerm_dns_zone.domain.name
  resource_group_name = azurerm_resource_group.dns_rg.name
  ttl                 = var.default_ttl
  
  dynamic "record" {
    for_each = var.mx_records
    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}
```

This creates MX (Mail Exchange) records which specify mail servers responsible for accepting email messages on behalf of the domain. Key points:
- Only created if there are MX records defined in the `mx_records` variable
- Each record includes a preference value (priority) and an exchange (mail server hostname)
- Lower preference values have higher priority

## Testing and Implementation

After deploying these resources, students should:

1. **Note the nameservers**: Capture the nameservers from the `azurerm_dns_zone.domain.name_servers` output

2. **Update domain registrar**: Configure their domain registrar (e.g., GoDaddy, Namecheap) to use Azure's nameservers

3. **Wait for propagation**: DNS changes can take 24-48 hours to propagate globally

4. **Test the configuration**: Use `nslookup` or similar tools to verify record resolution:
   ```bash
   # Check nameservers
   nslookup -type=NS example.com
   
   # Check A record
   nslookup www.example.com
   
   # Check MX records
   nslookup -type=MX example.com
   ```

## Common Issues and Solutions

1. **DNS propagation delays**: DNS changes take time to propagate. Students should wait at least a few hours before concluding there's an issue.

2. **Nameserver configuration errors**: Ensure all Azure nameservers are properly configured at the domain registrar.

3. **Record conflicts**: Each record name must be unique within its type. If deployment fails due to conflicts, check for duplicate record names.

4. **Domain validation issues**: For services requiring domain validation (e.g., SSL certificates), ensure TXT records are created exactly as specified by the service provider.

5. **Permissions issues**: Ensure the Azure account has sufficient permissions to manage DNS zones.

## Advanced Configurations

For more advanced scenarios, students can:

1. **Configure ALIAS records**: For apex domains that need to point to Azure services like App Service or Traffic Manager

2. **Implement CAA records**: Certificate Authority Authorization records to specify which CAs can issue certificates for the domain

3. **Set up split-horizon DNS**: Configure different responses based on the source of the DNS query

4. **Configure Private DNS zones**: For name resolution in private networks (VNets) without exposing resources to the internet

5. **Use Traffic Manager with DNS**: Set up global traffic routing for high availability

## Best Practices for DNS Management

1. **Use descriptive record names and comments**: Clear naming helps with maintenance

2. **Implement proper TTL values**: Lower TTLs for records that might change frequently, higher TTLs for stable records

3. **Document all DNS records**: Keep a record of all DNS changes, especially for services that require specific DNS configurations

4. **Backup DNS configurations**: Export or backup DNS configurations regularly

5. **Use tags for better organization**: Apply meaningful tags to DNS resources for better management

6. **Monitor DNS performance**: Set up monitoring to ensure DNS resolution is working properly

## Additional Resources

Refer students to these helpful resources:

1. Azure DNS documentation: https://docs.microsoft.com/en-us/azure/dns/

2. DNS best practices: https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/name-and-label-resources#dns 