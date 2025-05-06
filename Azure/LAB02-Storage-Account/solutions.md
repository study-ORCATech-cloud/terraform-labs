# LAB02: Azure Storage Account Solution

This document provides solutions for the Azure Storage Account lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "storage_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a storage account
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
    
    container_delete_retention_policy {
      days = 7
    }
  }
  
  tags = var.tags
}

# Create a blob container
resource "azurerm_storage_container" "blob_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_access_type
}

# Configure static website hosting (optional)
resource "azurerm_storage_account_static_website" "static_website" {
  count = var.enable_static_website ? 1 : 0
  
  storage_account_id = azurerm_storage_account.storage_account.id
  
  index_document     = var.index_document
  error_404_document = var.error_404_document
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
resource "azurerm_resource_group" "storage_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for the storage resources:
- Sets the name using the variable `resource_group_name`
- Sets the location (Azure region) using the variable `location`
- Applies tags defined in the `tags` variable for better organization

### 3. Create a Storage Account

```terraform
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.storage_rg.name
  location                 = azurerm_resource_group.storage_rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    versioning_enabled = true
    
    delete_retention_policy {
      days = 7
    }
    
    container_delete_retention_policy {
      days = 7
    }
  }
  
  tags = var.tags
}
```

This creates a general-purpose v2 storage account with the following configurations:
- Globally unique name specified by `storage_account_name`
- Performance tier specified by `account_tier` (Standard or Premium)
- Data redundancy specified by `account_replication_type` (LRS, GRS, etc.)
- Storage account kind set to "StorageV2" for latest features
- Minimum TLS version set to 1.2 for security
- Blob properties including versioning and retention policies
- Tags for resource organization

### 4. Create a Blob Container

```terraform
resource "azurerm_storage_container" "blob_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_access_type
}
```

This creates a container within the storage account:
- Container name specified by `container_name`
- Access type specified by `container_access_type`:
  - `private`: No anonymous access
  - `blob`: Anonymous read access for blobs only
  - `container`: Anonymous read access for entire container

### 5. Configure Static Website Hosting (Optional)

```terraform
resource "azurerm_storage_account_static_website" "static_website" {
  count = var.enable_static_website ? 1 : 0
  
  storage_account_id = azurerm_storage_account.storage_account.id
  
  index_document     = var.index_document
  error_404_document = var.error_404_document
}
```

This conditionally enables static website hosting if `enable_static_website` is true:
- Uses the `count` parameter to make this resource optional
- Specifies the index and error documents
- Links to the storage account created earlier

## Variables and Outputs

### Important Variables

- **storage_account_name**: Must be globally unique, lowercase alphanumeric, 3-24 characters
- **account_tier**: Determines performance (Standard or Premium)
- **account_replication_type**: Determines redundancy (LRS, GRS, RAGRS, ZRS)
- **container_access_type**: Determines public access level to container
- **enable_static_website**: Boolean to enable/disable static website hosting

### Key Outputs

- **primary_blob_endpoint**: The URL to access the blob service
- **blob_container_url**: The URL for the specific container
- **static_website_url**: The URL for the static website (if enabled)
- **primary_access_key** and **connection_string**: For programmatic access to the storage account

## Common Issues and Solutions

1. **Storage account name already exists**: Azure storage account names must be globally unique - try a different name
2. **Access denied errors**: Check container access type and ensure necessary permissions
3. **Static website not accessible**: Verify that static website hosting is enabled and index document is correct
4. **Blob not visible**: Ensure container access type allows public access if needed

## Advanced Customizations

For more complex deployments, consider:

1. Enabling CORS for web applications:
```terraform
resource "azurerm_storage_account" "storage_account" {
  # ... other configuration ...
  
  blob_properties {
    # ... other properties ...
    
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "POST", "PUT"]
      allowed_origins    = ["https://example.com"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
}
```

2. Configuring a lifecycle management policy:
```terraform
resource "azurerm_storage_management_policy" "lifecycle_policy" {
  storage_account_id = azurerm_storage_account.storage_account.id

  rule {
    name    = "archive-after-90-days"
    enabled = true
    filters {
      prefix_match = ["container1/path1"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_archive_after_days_since_modification_greater_than = 90
        delete_after_days_since_modification_greater_than          = 365
      }
    }
  }
}
```

3. Setting up a private endpoint for secure access:
```terraform
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.storage_account_name}-endpoint"
  location            = azurerm_resource_group.storage_rg.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${var.storage_account_name}-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
```

## Security Best Practices

1. **Enable Encryption**: Azure Storage is encrypted by default, but you can use customer-managed keys
2. **Use Private Endpoints**: For sensitive data, use private endpoints instead of public access
3. **Apply Access Controls**: Use the least permissive container access type required
4. **Enable Versioning**: Keep history of blob changes to protect against accidental deletion or corruption
5. **Configure Retention Policies**: Implement soft delete with appropriate retention periods 