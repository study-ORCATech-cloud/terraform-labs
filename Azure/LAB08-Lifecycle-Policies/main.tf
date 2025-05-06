# TODO: Configure the Azure Provider
# Requirements:
# - Set the features block
# - Use Azure Resource Manager (AzureRM)

provider "azurerm" {
  # TODO: Configure the features block with appropriate settings
  features {}
}

# TODO: Create a Resource Group for storage resources
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create a Storage Account
# Requirements:
# - Use azurerm_storage_account resource
# - Set name using var.storage_account_name
# - Set account_tier to "Standard"
# - Set account_replication_type to var.replication_type (e.g., "LRS", "GRS")
# - Set account_kind to "StorageV2" (required for tiered storage)
# - Set access_tier to "Hot"
# - Enable hierarchical_namespace if var.enable_adls_gen2 is true
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create Storage Containers
# Requirements:
# - Use azurerm_storage_container resource
# - Create a container for each name in var.container_names
# - Set container_access_type to "private"
# - Reference the storage account you created

# TODO: Define Storage Lifecycle Management Policy
# Requirements:
# - Use azurerm_storage_management_policy resource
# - Reference the storage account you created
# - Create rules according to var.lifecycle_rules configuration
# - Each rule should include:
#   - Name (from var.lifecycle_rules[].name)
#   - Enabled status (from var.lifecycle_rules[].enabled)
#   - Filters (prefix_match, blob_types)
#   - Actions (base_blob.tier_to_cool, base_blob.tier_to_archive, base_blob.delete)
#   - Each action should have appropriate days_after_*_time settings

# (Optional) TODO: Configure Container with WORM (Write Once, Read Many) Policy
# Requirements:
# - Use azurerm_storage_container_immutability_policy resource
# - Set immutability_period_since_creation_in_days to var.immutability_period
# - Set container_resource_id to the target container's ID
# - Set allow_protected_append_writes to true
# - Only create this resource if var.enable_immutability is true 
