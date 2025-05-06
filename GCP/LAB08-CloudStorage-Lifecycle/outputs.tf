# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "primary_bucket_name" {
  description = "Name of the primary Cloud Storage bucket"
  value       = google_storage_bucket.primary_bucket.name
}

output "primary_bucket_url" {
  description = "URL of the primary Cloud Storage bucket"
  value       = google_storage_bucket.primary_bucket.url
}

output "primary_bucket_lifecycle_rules" {
  description = "Lifecycle rules for the primary bucket"
  value = [
    for rule in google_storage_bucket.primary_bucket.lifecycle_rule : {
      action    = rule.action
      condition = rule.condition
    }
  ]
}

output "secondary_bucket_name" {
  description = "Name of the secondary Cloud Storage bucket (with versioning)"
  value       = google_storage_bucket.versioned_bucket.name
}

output "secondary_bucket_url" {
  description = "URL of the secondary Cloud Storage bucket"
  value       = google_storage_bucket.versioned_bucket.url
}

output "secondary_bucket_versioning" {
  description = "Versioning status for the secondary bucket"
  value       = google_storage_bucket.versioned_bucket.versioning[0].enabled ? "Enabled" : "Disabled"
}

output "secondary_bucket_lifecycle_rules" {
  description = "Lifecycle rules for the secondary bucket"
  value = [
    for rule in google_storage_bucket.versioned_bucket.lifecycle_rule : {
      action    = rule.action
      condition = rule.condition
    }
  ]
}

output "prefix_bucket_name" {
  description = "Name of the bucket with prefix-based rules (if created)"
  value       = var.create_prefix_bucket ? google_storage_bucket.prefix_bucket[0].name : "Not created"
}

output "prefix_bucket_lifecycle_rules" {
  description = "Lifecycle rules for the prefix bucket (if created)"
  value = var.create_prefix_bucket ? [
    for rule in google_storage_bucket.prefix_bucket[0].lifecycle_rule : {
      action    = rule.action
      condition = rule.condition
    }
  ] : []
}

output "console_url_primary" {
  description = "URL to access the primary bucket in the Cloud Console"
  value       = "https://console.cloud.google.com/storage/browser/${google_storage_bucket.primary_bucket.name}?project=${var.project_id}"
}

output "console_url_secondary" {
  description = "URL to access the secondary bucket in the Cloud Console"
  value       = "https://console.cloud.google.com/storage/browser/${google_storage_bucket.versioned_bucket.name}?project=${var.project_id}"
}

output "example_gsutil_upload" {
  description = "Example gsutil command to upload files"
  value       = "gsutil cp [LOCAL_FILE] gs://${google_storage_bucket.primary_bucket.name}/"
}

output "example_gsutil_lifecycle_get" {
  description = "Example gsutil command to view lifecycle configuration"
  value       = "gsutil lifecycle get gs://${google_storage_bucket.primary_bucket.name}"
} 
