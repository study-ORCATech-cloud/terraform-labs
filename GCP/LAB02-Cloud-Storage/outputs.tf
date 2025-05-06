# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "bucket_name" {
  description = "The name of the bucket"
  value       = google_storage_bucket.bucket.name
}

output "bucket_url" {
  description = "The base URL of the bucket"
  value       = google_storage_bucket.bucket.url
}

output "bucket_self_link" {
  description = "The self_link of the bucket"
  value       = google_storage_bucket.bucket.self_link
}

output "bucket_location" {
  description = "The location of the bucket"
  value       = google_storage_bucket.bucket.location
}

output "bucket_storage_class" {
  description = "The storage class of the bucket"
  value       = google_storage_bucket.bucket.storage_class
}

output "gsutil_ls_command" {
  description = "Command to list objects in the bucket"
  value       = "gsutil ls gs://${google_storage_bucket.bucket.name}"
}

output "gsutil_cp_example" {
  description = "Example command to upload a file to the bucket"
  value       = "gsutil cp /path/to/local/file gs://${google_storage_bucket.bucket.name}/"
}

output "website_url" {
  description = "The URL of the static website (if enabled)"
  value       = var.enable_website ? "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/index.html" : "Website hosting not enabled"
} 
