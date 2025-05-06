# TODO: Configure the Azure Provider
# Requirements:
# - Set the features block
# - Use Azure Resource Manager (AzureRM)

provider "azurerm" {
  # TODO: Configure the features block with appropriate settings
  features {}
}

# TODO: Create a Resource Group for database resources
# Requirements:
# - Use azurerm_resource_group resource
# - Set name using var.resource_group_name
# - Set location using var.location
# - Apply tags using var.tags

# TODO: Create an Azure SQL Server
# Requirements:
# - Use azurerm_mssql_server resource
# - Set name using var.sql_server_name
# - Set administrator_login using var.admin_username
# - Set administrator_login_password using var.admin_password
# - Set version to "12.0" (latest stable)
# - Set minimum_tls_version to "1.2"
# - Reference the resource group you created
# - Apply tags using var.tags

# TODO: Configure SQL Server Firewall Rules
# Requirements:
# - Use azurerm_mssql_firewall_rule resource
# - Create a rule named "AllowAzureServices" that enables Azure services access
# - Create rules for each IP in var.allowed_ip_addresses list with names like "ClientIPx"
# - Reference the SQL server and resource group you created
# - Only create client IP rules if var.allowed_ip_addresses is not empty

# TODO: Create an Azure SQL Database
# Requirements:
# - Use azurerm_mssql_database resource
# - Set name using var.database_name
# - Set sku_name to var.database_sku
# - Set collation to "SQL_Latin1_General_CP1_CI_AS" (or use var.database_collation)
# - Set max_size_gb to var.max_size_gb
# - Configure auto_pause_delay_in_minutes if using serverless SKU
# - Configure short_term_retention_policy for point-in-time restore
# - Reference the SQL server and resource group you created
# - Apply tags using var.tags

# TODO (Optional): Configure Database Auditing
# Requirements:
# - Use azurerm_mssql_database_extended_auditing_policy resource
# - Set retention_in_days to var.log_retention_days
# - Configure storage_endpoint and storage_account_access_key
# - Reference the SQL database you created
# - Only implement this if var.enable_auditing is true

# TODO (Optional): Configure Transparent Data Encryption
# Requirements:
# - Use azurerm_mssql_database_transparent_data_encryption resource
# - Set state to "Enabled"
# - Reference the SQL database you created
# - Only implement this if var.enable_encryption is true 
