# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "function_name" {
  description = "Name of the Cloud Function"
  value       = google_cloudfunctions_function.function.name
}

output "function_region" {
  description = "Region of the Cloud Function"
  value       = google_cloudfunctions_function.function.region
}

output "function_url" {
  description = "URL of the Cloud Function"
  value       = google_cloudfunctions_function.function.https_trigger_url
}

output "function_status" {
  description = "Status of the Cloud Function"
  value       = google_cloudfunctions_function.function.status
}

output "function_version" {
  description = "Version of the Cloud Function"
  value       = google_cloudfunctions_function.function.version_id
}

output "function_runtime" {
  description = "Runtime of the Cloud Function"
  value       = google_cloudfunctions_function.function.runtime
}

output "function_memory" {
  description = "Memory allocation of the Cloud Function"
  value       = "${google_cloudfunctions_function.function.available_memory_mb} MB"
}

output "function_timeout" {
  description = "Timeout of the Cloud Function"
  value       = "${google_cloudfunctions_function.function.timeout} seconds"
}

output "function_entry_point" {
  description = "Entry point of the Cloud Function"
  value       = google_cloudfunctions_function.function.entry_point
}

output "storage_bucket" {
  description = "Storage bucket used for the function code"
  value       = google_storage_bucket.function_bucket.name
}

output "storage_bucket_url" {
  description = "Storage bucket URL"
  value       = google_storage_bucket.function_bucket.url
}

output "console_url" {
  description = "URL to access the Cloud Function in the console"
  value       = "https://console.cloud.google.com/functions/details/${var.region}/${google_cloudfunctions_function.function.name}?project=${var.project_id}"
}

output "curl_command" {
  description = "Example curl command to call the function"
  value       = "curl '${google_cloudfunctions_function.function.https_trigger_url}?name=YourName'"
}

output "browser_link" {
  description = "Link to open in browser with a query parameter"
  value       = "${google_cloudfunctions_function.function.https_trigger_url}?name=GCP"
} 
