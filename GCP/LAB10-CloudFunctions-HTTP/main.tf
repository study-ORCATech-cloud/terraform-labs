provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Enable the Cloud Functions API
# Requirements:
# - Use the google_project_service resource
# - Enable "cloudfunctions.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Enable the Cloud Build API (required for Cloud Functions deployment)
# Requirements:
# - Use the google_project_service resource
# - Enable "cloudbuild.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Create a Cloud Storage bucket for function code
# Requirements:
# - Use google_storage_bucket resource
# - Set a globally unique name using var.bucket_name
# - Configure the location using var.bucket_location
# - Set uniform bucket-level access to true
# - Apply labels from var.labels
# - Set force_destroy to true for easy lab cleanup

# TODO: Create a Cloud Storage bucket object for the function code archive
# Requirements:
# - Use google_storage_bucket_object resource
# - Set the name for the object (e.g., "function.zip")
# - Set the bucket to reference the bucket you created
# - Set the source to the local zip file path
# - If using a source_directory instead, configure the appropriate options

# TODO: Create a Cloud Function with HTTP trigger
# Requirements:
# - Use google_cloudfunctions_function resource
# - Set name using var.function_name
# - Set the location to match your region
# - Configure source_archive_bucket and source_archive_object to point to the uploaded zip
# - Set entry_point to the function name in your code (e.g., "hello_http")
# - Set trigger_http to true to create an HTTP trigger
# - Set runtime based on var.function_runtime (e.g., "python310")
# - Configure available_memory_mb if specified in vars
# - Configure timeout if specified in vars
# - Set environment variables if provided
# - Set the service account if provided 
