# LAB08: Azure Storage Lifecycle Policies Solution

This document provides solutions for the Azure Storage Lifecycle Policies lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group for storage resources
resource "azurerm_resource_group" "lifecycle_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a Storage Account
resource "azurerm_storage_account" "lifecycle_sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.lifecycle_rg.name
  location                 = azurerm_resource_group.lifecycle_rg.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  is_hns_enabled           = var.enable_adls_gen2
  
  # Security settings
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
  
  # Enable blob lifecycle management
  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true
  }
  
  tags = var.tags
}

# Create Storage Containers
resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.container_names)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.lifecycle_sa.name
  container_access_type = "private"
}

# Define Storage Lifecycle Management Policy
resource "azurerm_storage_management_policy" "lifecycle_policy" {
  storage_account_id = azurerm_storage_account.lifecycle_sa.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled
      
      filters {
        prefix_match = rule.value.filters.prefix_match
        blob_types   = rule.value.filters.blob_types
      }
      
      actions {
        base_blob {
          # Only apply tier_to_cool action if days value is positive
          dynamic "tier_to_cool" {
            for_each = rule.value.actions.tier_to_cool_after_days > 0 ? [1] : []
            content {
              days_after_modification_greater_than = rule.value.actions.tier_to_cool_after_days
            }
          }
          
          # Only apply tier_to_archive action if days value is positive
          dynamic "tier_to_archive" {
            for_each = rule.value.actions.tier_to_archive_after_days > 0 ? [1] : []
            content {
              days_after_modification_greater_than = rule.value.actions.tier_to_archive_after_days
            }
          }
          
          # Only apply delete action if days value is positive
          dynamic "delete" {
            for_each = rule.value.actions.delete_after_days > 0 ? [1] : []
            content {
              days_after_modification_greater_than = rule.value.actions.delete_after_days
            }
          }
        }
      }
    }
  }
}

# (Optional) Configure Container with WORM (Write Once, Read Many) Policy
resource "azurerm_storage_container_immutability_policy" "immutability" {
  count                               = var.enable_immutability ? 1 : 0
  container_resource_id               = azurerm_storage_container.containers[var.immutable_container_name].resource_manager_id
  immutability_period_since_creation_in_days = var.immutability_period
  allow_protected_append_writes       = true

  depends_on = [
    azurerm_storage_container.containers
  ]
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
resource "azurerm_resource_group" "lifecycle_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for all the resources in this lab.

### 3. Create a Storage Account

```terraform
resource "azurerm_storage_account" "lifecycle_sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.lifecycle_rg.name
  location                 = azurerm_resource_group.lifecycle_rg.location
  account_tier             = "Standard"
  account_replication_type = var.replication_type
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  is_hns_enabled           = var.enable_adls_gen2
  
  # Security settings
  min_tls_version          = "TLS1_2"
  allow_blob_public_access = false
  
  # Enable blob lifecycle management
  blob_properties {
    change_feed_enabled = true
    versioning_enabled  = true
  }
  
  tags = var.tags
}
```

This creates an Azure Storage Account with the following key features:
- `account_kind` is set to "StorageV2", which is required for tiered storage and lifecycle management
- `access_tier` sets the default tier for new blobs to "Hot"
- `is_hns_enabled` enables hierarchical namespace for Data Lake Storage Gen2 features (if requested)
- Security settings like `min_tls_version` and disabling public access are applied
- `blob_properties` block enables change feed and versioning (useful for tracking and managing blob changes)

### 4. Create Storage Containers

```terraform
resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.container_names)
  name                  = each.value
  storage_account_name  = azurerm_storage_account.lifecycle_sa.name
  container_access_type = "private"
}
```

This creates a container for each name in the `container_names` list. The `for_each` loop is used to iterate through the list and create multiple containers. All containers are set to "private" access to enhance security.

### 5. Define Storage Lifecycle Management Policy

```terraform
resource "azurerm_storage_management_policy" "lifecycle_policy" {
  storage_account_id = azurerm_storage_account.lifecycle_sa.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      name    = rule.value.name
      enabled = rule.value.enabled
      
      filters {
        prefix_match = rule.value.filters.prefix_match
        blob_types   = rule.value.filters.blob_types
      }
      
      actions {
        base_blob {
          # Only apply tier_to_cool action if days value is positive
          dynamic "tier_to_cool" {
            for_each = rule.value.actions.tier_to_cool_after_days > 0 ? [1] : []
            content {
              days_after_modification_greater_than = rule.value.actions.tier_to_cool_after_days
            }
          }
          
          # Only apply tier_to_archive action if days value is positive
          dynamic "tier_to_archive" {
            for_each = rule.value.actions.tier_to_archive_after_days > 0 ? [1] : []
            content {
              days_after_modification_greater_than = rule.value.actions.tier_to_archive_after_days
            }
          }
          
          # Only apply delete action if days value is positive
          dynamic "delete" {
            for_each = rule.value.actions.delete_after_days > 0 ? [1] : []
            content {
              days_after_modification_greater_than = rule.value.actions.delete_after_days
            }
          }
        }
      }
    }
  }
}
```

This creates the lifecycle management policy with the following features:
- Uses a `dynamic` block to create rules for each entry in the `lifecycle_rules` variable
- Each rule has a name, enabled status, filters, and actions
- Filters can specify which blobs the rule applies to by prefix and blob type
- Actions determine what happens to blobs at specific time thresholds:
  - `tier_to_cool` moves blobs to the cool access tier after a specified number of days
  - `tier_to_archive` moves blobs to the archive access tier after a specified number of days
  - `delete` permanently removes blobs after a specified number of days
- Each action is conditionally created using nested dynamic blocks (only if the days value is positive)

### 6. Configure Container with WORM (Write Once, Read Many) Policy (Optional)

```terraform
resource "azurerm_storage_container_immutability_policy" "immutability" {
  count                               = var.enable_immutability ? 1 : 0
  container_resource_id               = azurerm_storage_container.containers[var.immutable_container_name].resource_manager_id
  immutability_period_since_creation_in_days = var.immutability_period
  allow_protected_append_writes       = true

  depends_on = [
    azurerm_storage_container.containers
  ]
}
```

This configures an immutability policy (also known as WORM - Write Once, Read Many) for the specified container. Key points:
- Only created if `enable_immutability` is set to true (using the `count` parameter)
- Links to a specific container using its resource manager ID
- Sets an immutability period during which blobs cannot be modified or deleted
- Allows protected append writes, which means new data can be added to appendable blobs
- Uses `depends_on` to ensure the container is created first

## Configuration Patterns Used

### 1. Dynamic Block Pattern

The dynamic block pattern in the lifecycle policy is a powerful technique for creating a variable number of similar configuration blocks based on input variables. This allows students to define multiple lifecycle rules in a single variable.

### 2. For Each Loop Pattern

The `for_each` loop used for container creation demonstrates how to create multiple similar resources without repeating code. This is a common pattern in Terraform for resource collections.

### 3. Conditional Resource Creation Pattern

Both the immutability policy and the actions within the lifecycle rules use conditional creation techniques:
- Count-based conditional creation for the immutability policy
- Nested dynamic blocks with condition-based iteration for lifecycle actions

## Testing the Lifecycle Policy

After applying the configuration, students can test the lifecycle policy by:

1. **Uploading test blobs**: Use the Azure Portal, Azure Storage Explorer, or Azure CLI to upload blobs to different containers

2. **Waiting for policy evaluation**: Lifecycle policies are evaluated by Azure every 24 hours, so immediate effects won't be visible

3. **Simulating time passage**: To avoid waiting for actual time to pass, students can upload blobs with older modification dates using tools like AzCopy with the appropriate flags

4. **Monitoring in Azure Portal**: View the effects of the lifecycle policy in the Azure Portal under the storage account's "Lifecycle Management" section

## Common Issues and Solutions

1. **Storage account name conflicts**: Azure Storage account names must be globally unique. If deployment fails with a conflict, change the `storage_account_name` variable.

2. **Immutability policy conflicts**: Once an immutability policy is applied, it can't be removed without special procedures. It's recommended to use this only for testing and with short periods.

3. **Lifecycle policy not taking effect**: Remember that lifecycle policies are evaluated every 24 hours, so effects aren't immediate.

4. **Incorrect prefix filters**: Ensure prefix filters include the container name if targeting specific containers.

5. **Missing permissions**: Ensure the Azure account has sufficient permissions to manage storage policies.

## Advanced Scenarios

For more advanced implementations, consider:

1. **Tag-Based Filtering**: Use tags to determine lifecycle actions (requires additional management)

2. **Multiple Tiering Strategies**: Implement different tiering strategies for different types of data

3. **Legal Hold**: Implement legal hold in addition to immutability policies for compliance scenarios

4. **Access Tracking**: Configure last access tracking to move blobs based on access patterns rather than just creation/modification dates

5. **Integration with Azure Defender for Storage**: Enable threat protection alongside lifecycle management 