# NOTE: These outputs reference resources that you need to implement in main.tf
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.sql_rg.name
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.sql_server.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}

output "database_name" {
  description = "Name of the SQL Database"
  value       = azurerm_mssql_database.sql_db.name
}

output "connection_string" {
  description = "Connection string for the SQL Database (without password)"
  value       = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql_db.name};Persist Security Info=False;User ID=${var.admin_username};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  # Note: Password is intentionally excluded for security reasons
}

output "allowed_ip_addresses" {
  description = "IP addresses allowed to access the SQL Server"
  value       = var.allowed_ip_addresses
}

output "azure_services_access_enabled" {
  description = "Whether Azure services can access the SQL Server"
  value       = var.enable_azure_services
}

output "sql_database_id" {
  description = "ID of the SQL Database"
  value       = azurerm_mssql_database.sql_db.id
}

output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = azurerm_mssql_server.sql_server.id
}

output "encryption_enabled" {
  description = "Whether Transparent Data Encryption is enabled"
  value       = var.enable_encryption
}

output "connect_with_azure_cli" {
  description = "Command to connect to the database with Azure CLI"
  value       = "az sql db show-connection-string --client sqlcmd --name ${azurerm_mssql_database.sql_db.name} --server ${azurerm_mssql_server.sql_server.name}"
}

output "portal_url" {
  description = "URL to access the SQL Database in Azure Portal"
  value       = "https://portal.azure.com/#resource${azurerm_mssql_database.sql_db.id}/overview"
} 
