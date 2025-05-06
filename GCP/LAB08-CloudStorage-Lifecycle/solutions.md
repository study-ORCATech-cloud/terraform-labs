# LAB08: Cloud Storage and Object Lifecycle Management Solutions

This document provides solutions for the Cloud Storage Lifecycle Management lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable the Cloud Storage API
resource "google_project_service" "storage_api" {
  service                    = "storage.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Create a primary Cloud Storage bucket
resource "google_storage_bucket" "primary_bucket" {
  name          = var.primary_bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true

  uniform_bucket_level_access = true
  labels                      = var.labels

  # Basic lifecycle rule for age-based deletion
  lifecycle_rule {
    condition {
      age = var.age_in_days
    }
    action {
      type = "Delete"
    }
  }

  # Storage class transition rule
  lifecycle_rule {
    condition {
      age = var.transition_age_in_days
    }
    action {
      type          = "SetStorageClass"
      storage_class = var.transition_storage_class
    }
  }

  # Conditional prefix-based rules (if enabled)
  dynamic "lifecycle_rule" {
    for_each = var.apply_prefix_filter ? var.prefix_filters : {}

    content {
      condition {
        age    = lifecycle_rule.value.age_in_days
        prefix = lifecycle_rule.value.prefix
      }
      action {
        type = "Delete"
      }
    }
  }

  depends_on = [google_project_service.storage_api]
}

# Create a secondary bucket with versioning enabled
resource "google_storage_bucket" "versioned_bucket" {
  name          = var.secondary_bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true

  uniform_bucket_level_access = true
  labels                      = var.labels

  # Enable versioning
  versioning {
    enabled = true
  }

  # Delete old versions after specified days
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = var.noncurrent_age_in_days
    }
    action {
      type = "Delete"
    }
  }

  # Limit number of versions per object
  lifecycle_rule {
    condition {
      num_newer_versions = var.num_versions_to_keep
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.storage_api]
}

# Create an optional bucket with prefix-based rules
resource "google_storage_bucket" "prefix_bucket" {
  count = var.create_prefix_bucket ? 1 : 0

  name          = var.prefix_bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true

  uniform_bucket_level_access = true
  labels                      = var.labels

  # Generate dynamic lifecycle rules for each prefix
  dynamic "lifecycle_rule" {
    for_each = var.prefix_filters

    content {
      condition {
        age    = lifecycle_rule.value.age_in_days
        prefix = lifecycle_rule.value.prefix
      }
      action {
        type = "Delete"
      }
    }
  }

  # Example: Transition logs to COLDLINE after 30 days before deletion
  lifecycle_rule {
    condition {
      age    = 30
      prefix = "logs/"
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  # Example: Delete tmp folder contents after 1 day
  lifecycle_rule {
    condition {
      age    = 1
      prefix = "tmp/"
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.storage_api]
}
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}
```

This configures the Google Cloud provider with your project ID and region. Using variables allows flexibility across different environments.

### 2. Enable Required API

```terraform
resource "google_project_service" "storage_api" {
  service                    = "storage.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}
```

This enables the Cloud Storage API which is required to create and manage Cloud Storage buckets. The resource:
- Specifies the API service to enable
- Sets `disable_on_destroy` to true to disable the API when you run `terraform destroy`
- Sets custom timeouts to allow for API activation, which can take time
- Disables dependent services when destroying to prevent orphaned resources

### 3. Create a Primary Cloud Storage Bucket

```terraform
resource "google_storage_bucket" "primary_bucket" {
  name          = var.primary_bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = true

  uniform_bucket_level_access = true
  labels                      = var.labels
  
  # ... lifecycle rules ...

  depends_on = [google_project_service.storage_api]
}
```

This creates a Cloud Storage bucket with basic configuration:
- Sets a globally unique bucket name
- Configures the location (region or multi-region)
- Sets the initial storage class (STANDARD, NEARLINE, etc.)
- Enables uniform bucket-level access for better security
- Sets `force_destroy` to true to allow Terraform to delete the bucket even if it contains objects
- Applies labels for resource organization and cost tracking
- Depends on the Storage API being enabled

### 4. Configure Basic Lifecycle Rules

```terraform
# Basic lifecycle rule for age-based deletion
lifecycle_rule {
  condition {
    age = var.age_in_days
  }
  action {
    type = "Delete"
  }
}

# Storage class transition rule
lifecycle_rule {
  condition {
    age = var.transition_age_in_days
  }
  action {
    type          = "SetStorageClass"
    storage_class = var.transition_storage_class
  }
}
```

These rules implement common lifecycle policies:
1. **Age-based deletion**: Automatically deletes objects that are older than a certain number of days
2. **Storage class transition**: Moves objects to a cheaper storage class after they reach a certain age

### 5. Add Conditional Prefix-Based Rules

```terraform
dynamic "lifecycle_rule" {
  for_each = var.apply_prefix_filter ? var.prefix_filters : {}

  content {
    condition {
      age    = lifecycle_rule.value.age_in_days
      prefix = lifecycle_rule.value.prefix
    }
    action {
      type = "Delete"
    }
  }
}
```

This dynamically creates lifecycle rules based on object prefixes:
- Uses a dynamic block to create rules only if `apply_prefix_filter` is true
- Iterates through the prefix filter map to create rules for each prefix
- Sets different age conditions for different prefixes (e.g., delete logs after 14 days, but temp files after 1 day)

### 6. Create a Versioned Bucket

```terraform
resource "google_storage_bucket" "versioned_bucket" {
  # ... basic configuration ...

  # Enable versioning
  versioning {
    enabled = true
  }

  # Delete old versions after specified days
  lifecycle_rule {
    condition {
      days_since_noncurrent_time = var.noncurrent_age_in_days
    }
    action {
      type = "Delete"
    }
  }

  # Limit number of versions per object
  lifecycle_rule {
    condition {
      num_newer_versions = var.num_versions_to_keep
    }
    action {
      type = "Delete"
    }
  }
}
```

This creates a bucket with versioning enabled and version-specific lifecycle rules:
- The `versioning` block enables object versioning, which keeps previous versions when objects are overwritten
- The first lifecycle rule deletes non-current (previous) object versions after a specified number of days
- The second lifecycle rule keeps only a limited number of versions by deleting older versions when there are more than `num_versions_to_keep` newer versions

### 7. Create a Bucket with Complex Prefix Rules (Optional)

```terraform
resource "google_storage_bucket" "prefix_bucket" {
  count = var.create_prefix_bucket ? 1 : 0
  
  # ... basic configuration ...

  # Generate dynamic lifecycle rules for each prefix
  dynamic "lifecycle_rule" {
    for_each = var.prefix_filters

    content {
      condition {
        age    = lifecycle_rule.value.age_in_days
        prefix = lifecycle_rule.value.prefix
      }
      action {
        type = "Delete"
      }
    }
  }

  # Additional specific rules
  # ...
}
```

This conditionally creates a bucket focused on prefix-based lifecycle management:
- Uses the `count` parameter to create the bucket only if `create_prefix_bucket` is true
- Creates a dynamic set of rules based on the prefix filters
- Adds specific examples of more complex rules, such as transitioning logs to COLDLINE before deleting them

## Variables and Outputs

### Important Variables

- **storage_class**: Sets the initial storage class for cost/performance balance
- **age_in_days**, **transition_age_in_days**: Define when actions should be taken
- **noncurrent_age_in_days**, **num_versions_to_keep**: Control versioning retention
- **prefix_filters**: Map of prefixes with specific retention policies

### Key Outputs

- **bucket URLs and names**: For accessing the created buckets
- **lifecycle_rules**: Shows the configured lifecycle policies
- **example commands**: Provides sample gsutil commands for working with the buckets

## Common Issues and Solutions

1. **Bucket name conflicts**: Ensure bucket names are globally unique by adding suffixes
2. **Permission denied**: Ensure your GCP account has Storage Admin role
3. **Lifecycle rules not taking effect immediately**: Changes to lifecycle rules can take up to 24 hours to fully propagate
4. **Cannot delete bucket**: Make sure `force_destroy` is set to true and all objects are deletable

## Advanced Customizations

For more complex deployments, consider:

1. Creating conditional rules based on multiple criteria:
```terraform
lifecycle_rule {
  condition {
    age                   = 30
    matches_storage_class = ["STANDARD"]
    created_before        = "2023-01-01"
  }
  action {
    type = "Delete"
  }
}
```

2. Setting up a retention policy for compliance requirements:
```terraform
retention_policy {
  is_locked        = true
  retention_period = 7776000 # 90 days in seconds
}
```

3. Configuring object lifecycle for archived storage with multi-stage transitions:
```terraform
# Move to NEARLINE after 30 days
lifecycle_rule {
  condition {
    age = 30
  }
  action {
    type          = "SetStorageClass"
    storage_class = "NEARLINE"
  }
}

# Move to COLDLINE after 90 days
lifecycle_rule {
  condition {
    age                   = 90
    matches_storage_class = ["NEARLINE"]
  }
  action {
    type          = "SetStorageClass"
    storage_class = "COLDLINE"
  }
}

# Move to ARCHIVE after 365 days
lifecycle_rule {
  condition {
    age                   = 365
    matches_storage_class = ["COLDLINE"]
  }
  action {
    type          = "SetStorageClass"
    storage_class = "ARCHIVE"
  }
}
``` 