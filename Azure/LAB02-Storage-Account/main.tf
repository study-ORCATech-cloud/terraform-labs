# TODO: Configure the Azure Provider
# Requirements:
# - Set the features block
# - Use Azure Resource Manager (AzureRM)

provider "azurerm" {
  # TODO: Configure the features block with appropriate settings
  features {}
}

# TODO: Create a Resource Group
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create a Storage Account
# Requirements:
# - Use azurerm_storage_account resource
# - Set name using var.storage_account_name
# - Set account_tier using var.account_tier
# - Set account_replication_type using var.account_replication_type
# - Enable blob encryption
# - Set account_kind to "StorageV2"
# - Configure min_tls_version to "TLS1_2"
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Create a Blob Container
# Requirements:
# - Use azurerm_storage_container resource
# - Set name using var.container_name
# - Set container_access_type using var.container_access_type
# - Reference the storage account you created

# TODO (Optional): Configure Static Website Hosting
# Requirements:
# - Use azurerm_storage_account_static_website resource
# - Set index_document and error_404_document
# - Reference the storage account you created
# - Only implement this if var.enable_static_website is true

# Hint: Use the following pattern for conditional resources
# count = var.enable_static_website ? 1 : 0 
