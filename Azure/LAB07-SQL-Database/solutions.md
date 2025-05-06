# LAB07: Azure SQL Database Solution

This document provides solutions for the Azure SQL Database lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group for database resources
resource "azurerm_resource_group" "sql_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create an Azure SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.sql_rg.name
  location                     = azurerm_resource_group.sql_rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

# Configure SQL Server Firewall Rules - Allow Azure Services
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count               = var.enable_azure_services ? 1 : 0
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.sql_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Configure SQL Server Firewall Rules - Client IPs
resource "azurerm_mssql_firewall_rule" "client_ips" {
  count            = length(var.allowed_ip_addresses)
  name             = "ClientIP${count.index + 1}"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = var.allowed_ip_addresses[count.index]
  end_ip_address   = var.allowed_ip_addresses[count.index]
}

# Create an Azure SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name                        = var.database_name
  server_id                   = azurerm_mssql_server.sql_server.id
  collation                   = var.database_collation
  sku_name                    = var.database_sku
  max_size_gb                 = var.max_size_gb
  tags                        = var.tags
  
  # Only set auto_pause_delay if using a serverless SKU (starting with GP_S)
  auto_pause_delay_in_minutes = startswith(var.database_sku, "GP_S") ? var.auto_pause_delay : null
  
  short_term_retention_policy {
    retention_days = 7
  }

  lifecycle {
    prevent_destroy = false # Set to true in production
  }
}

# Optional: Configure Database Auditing with Storage Account
resource "azurerm_storage_account" "audit_storage" {
  count                    = var.enable_auditing ? 1 : 0
  name                     = "${replace(var.sql_server_name, "-", "")}audit"
  resource_group_name      = azurerm_resource_group.sql_rg.name
  location                 = azurerm_resource_group.sql_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_mssql_database_extended_auditing_policy" "db_audit" {
  count                       = var.enable_auditing ? 1 : 0
  database_id                 = azurerm_mssql_database.sql_db.id
  storage_endpoint            = azurerm_storage_account.audit_storage[0].primary_blob_endpoint
  storage_account_access_key  = azurerm_storage_account.audit_storage[0].primary_access_key
  retention_in_days           = var.log_retention_days
}

# Optional: Configure Transparent Data Encryption
resource "azurerm_mssql_database_transparent_data_encryption" "db_encryption" {
  count       = var.enable_encryption ? 1 : 0
  database_id = azurerm_mssql_database.sql_db.id
  state       = "Enabled"
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
resource "azurerm_resource_group" "sql_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for all the resources in this lab.

### 3. Create an Azure SQL Server

```terraform
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.sql_rg.name
  location                     = azurerm_resource_group.sql_rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}
```

This creates an Azure SQL Server, which is a logical server that hosts one or more SQL databases. Key parameters:
- `version`: Set to "12.0" for the latest stable version
- `minimum_tls_version`: Set to "1.2" for improved security
- `administrator_login` and `administrator_login_password`: Credentials for the SQL Server administrator

### 4. Configure SQL Server Firewall Rules

```terraform
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count               = var.enable_azure_services ? 1 : 0
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.sql_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "client_ips" {
  count            = length(var.allowed_ip_addresses)
  name             = "ClientIP${count.index + 1}"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = var.allowed_ip_addresses[count.index]
  end_ip_address   = var.allowed_ip_addresses[count.index]
}
```

This configures firewall rules for the SQL Server:
- The first rule allows Azure services to access the SQL Server (if enabled)
- The second rule creates individual rules for each IP address in the `allowed_ip_addresses` list
- The `count` parameter ensures these resources are only created when needed

### 5. Create an Azure SQL Database

```terraform
resource "azurerm_mssql_database" "sql_db" {
  name                        = var.database_name
  server_id                   = azurerm_mssql_server.sql_server.id
  collation                   = var.database_collation
  sku_name                    = var.database_sku
  max_size_gb                 = var.max_size_gb
  tags                        = var.tags
  
  # Only set auto_pause_delay if using a serverless SKU (starting with GP_S)
  auto_pause_delay_in_minutes = startswith(var.database_sku, "GP_S") ? var.auto_pause_delay : null
  
  short_term_retention_policy {
    retention_days = 7
  }

  lifecycle {
    prevent_destroy = false # Set to true in production
  }
}
```

This creates the SQL Database within the SQL Server. Key parameters:
- `sku_name`: Sets the performance tier (e.g., Basic, Standard, Premium)
- `max_size_gb`: Sets the maximum size of the database
- `auto_pause_delay_in_minutes`: Only applies to serverless SKUs, determines when the database auto-pauses
- `short_term_retention_policy`: Configures point-in-time restore retention
- `prevent_destroy`: Safety mechanism to prevent accidental destruction (set to false for lab purposes)

### 6. Configure Database Auditing (Optional)

```terraform
resource "azurerm_storage_account" "audit_storage" {
  count                    = var.enable_auditing ? 1 : 0
  name                     = "${replace(var.sql_server_name, "-", "")}audit"
  resource_group_name      = azurerm_resource_group.sql_rg.name
  location                 = azurerm_resource_group.sql_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = var.tags
}

resource "azurerm_mssql_database_extended_auditing_policy" "db_audit" {
  count                       = var.enable_auditing ? 1 : 0
  database_id                 = azurerm_mssql_database.sql_db.id
  storage_endpoint            = azurerm_storage_account.audit_storage[0].primary_blob_endpoint
  storage_account_access_key  = azurerm_storage_account.audit_storage[0].primary_access_key
  retention_in_days           = var.log_retention_days
}
```

This configures database auditing, which tracks database events and writes them to a storage account. It's only created if `enable_auditing` is set to true.

### 7. Configure Transparent Data Encryption (Optional)

```terraform
resource "azurerm_mssql_database_transparent_data_encryption" "db_encryption" {
  count       = var.enable_encryption ? 1 : 0
  database_id = azurerm_mssql_database.sql_db.id
  state       = "Enabled"
}
```

This enables Transparent Data Encryption (TDE), which encrypts data at rest. It's only created if `enable_encryption` is set to true.

## Common Issues and Solutions

1. **SQL Server name conflicts**: Azure SQL Server names must be globally unique. If deployment fails with a conflict, change the `sql_server_name` variable.

2. **Firewall prevents connections**: Ensure your current IP address is added to the `allowed_ip_addresses` list or enable `allow_azure_services` if connecting from an Azure service.

3. **Password complexity errors**: SQL Server passwords must meet complexity requirements (length, character types). If deployment fails due to password validation, update `admin_password`.

4. **SKU limitations**: Some regions may not support all SKUs, or your subscription may have limitations. If deployment fails due to SKU issues, try a different SKU or region.

5. **Storage account name conflicts**: If using auditing and deployment fails due to storage account name conflicts, modify the naming pattern in the code.

## Accessing the SQL Database

After successful deployment, you can access the SQL Database using:

1. **SQL Server Management Studio (SSMS)**: Connect using the fully qualified domain name, admin username, and password.

2. **Azure Data Studio**: Connect using the connection string from the outputs.

3. **Azure Portal**: Navigate to the SQL Database resource in the Azure Portal.

4. **Azure CLI**: Use the command shown in the `connect_with_azure_cli` output.

## Security Best Practices

For production environments, consider these additional security measures:

1. **Private Endpoints**: Use Azure Private Link to expose SQL Server only on private networks.

2. **Azure AD Authentication**: Configure Azure Active Directory authentication instead of SQL authentication.

3. **Key Vault**: Store sensitive information like passwords in Azure Key Vault and reference them in Terraform.

4. **Advanced Threat Protection**: Enable Advanced Threat Protection for SQL Server.

5. **Network Security Groups**: Restrict network access to the SQL Server.

## Extending the Lab

For a more complete deployment, consider adding:

1. **Geo-replication**: Configure a geo-replicated secondary database for disaster recovery.

2. **Elastic Pool**: Create an elastic pool for multiple databases with shared resources.

3. **Azure SQL Database Serverless**: Use serverless tier for variable workloads and cost optimization.

4. **Dynamic Data Masking**: Configure data masking for sensitive columns.

5. **Backup Policies**: Configure long-term backup retention policies. 