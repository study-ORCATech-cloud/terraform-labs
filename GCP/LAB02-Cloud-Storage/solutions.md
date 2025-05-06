# LAB02: Cloud Storage Bucket Solutions

This document provides solutions for the Cloud Storage bucket lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = var.enable_versioning
  }
  
  dynamic "website" {
    for_each = var.enable_website ? [1] : []
    content {
      main_page_suffix = "index.html"
      not_found_page   = "404.html"
    }
  }
  
  dynamic "lifecycle_rule" {
    for_each = var.enable_lifecycle_rules ? [1] : []
    content {
      condition {
        age = var.lifecycle_age_days
      }
      action {
        type = "Delete"
      }
    }
  }
  
  labels = var.labels
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

This configures the Google Cloud provider with your project ID and region. These values are passed from variables, allowing flexibility across different environments.

### 2. Create a Cloud Storage Bucket

```terraform
resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = var.enable_versioning
  }
  
  labels = var.labels
}
```

This creates a Cloud Storage bucket with:

- **name**: The globally unique bucket name
- **location**: Can be a region (us-central1) or multi-region (US, EU, ASIA)
- **storage_class**: Determines price and availability (STANDARD, NEARLINE, COLDLINE, ARCHIVE)
- **uniform_bucket_level_access**: Modern access control using IAM instead of ACLs
- **versioning**: Optional feature to keep multiple versions of objects
- **labels**: Key-value pairs for organization and billing tracking

### 3. Configure Static Website Hosting (Optional)

```terraform
dynamic "website" {
  for_each = var.enable_website ? [1] : []
  content {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
```

This conditionally adds website hosting configuration if `enable_website` is true. The dynamic block:

- Only creates the website configuration when enabled
- Sets index.html as the main page
- Sets 404.html as the error page
- Makes the bucket accessible via https://storage.googleapis.com/BUCKET_NAME/index.html

### 4. Configure Lifecycle Rules (Optional)

```terraform
dynamic "lifecycle_rule" {
  for_each = var.enable_lifecycle_rules ? [1] : []
  content {
    condition {
      age = var.lifecycle_age_days
    }
    action {
      type = "Delete"
    }
  }
}
```

This conditionally adds lifecycle management rules if `enable_lifecycle_rules` is true:

- Only creates the rule when enabled
- Sets a condition to match objects older than the specified number of days
- Configures an action to delete matching objects
- Helps manage storage costs by automatically removing old data

## Variables and Outputs

### Important Variables

- **bucket_name**: Must be globally unique across all of GCP
- **location**: Affects availability, latency, and pricing
- **storage_class**: Balances access speed vs. cost
- **enable_versioning**: Preserves older versions of objects
- **enable_website**: Turns on static website hosting

### Key Outputs

- **bucket_url**: The base URL of the bucket
- **website_url**: The URL to access the website (if enabled)
- **gsutil commands**: Ready-to-use commands for managing objects

## Common Issues and Solutions

1. **Bucket name conflicts**: Bucket names must be globally unique - add a random suffix or prefix
2. **Permission denied**: Check your project IAM permissions
3. **Website not accessible**: Verify public access and correct file names
4. **Objects not deleted by lifecycle rules**: Rules only apply to new objects or during maintenance

## Advanced Customizations

For more complex deployments, consider:

1. Adding public access prevention:
```terraform
public_access_prevention = "enforced"
```

2. Configuring CORS for web applications:
```terraform
cors {
  origin          = ["https://example.com"]
  method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
  response_header = ["*"]
  max_age_seconds = 3600
}
```

3. Setting up object retention policies for compliance:
```terraform
retention_policy {
  retention_period = 2592000 # 30 days in seconds
}
```

4. Implementing bucket notifications to trigger Cloud Functions:
```terraform
notification {
  topic = google_pubsub_topic.topic.id
  payload_format = "JSON_API_V1"
  event_types = ["OBJECT_FINALIZE", "OBJECT_DELETE"]
}
``` 