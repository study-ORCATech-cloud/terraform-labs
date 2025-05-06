provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Enable the Cloud Storage API
# Requirements:
# - Use the google_project_service resource
# - Enable "storage.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Create a primary Cloud Storage bucket
# Requirements:
# - Use google_storage_bucket resource
# - Set a globally unique name using var.primary_bucket_name
# - Configure the location using var.bucket_location
# - Set appropriate storage class from var.storage_class
# - Enable uniform bucket-level access for better security
# - Apply labels from var.labels
# - Set force_destroy to true for easy lab cleanup

# TODO: Configure object lifecycle rules for the primary bucket
# Requirements:
# - Create a lifecycle_rule block within the bucket resource
# - Implement the following rules based on variables:
#   1. Age-based deletion: Delete objects older than var.age_in_days
#   2. Storage class transition: Change to var.transition_storage_class after var.transition_age_in_days
#   3. (Optional) Conditional rules based on object prefix if var.apply_prefix_filter is true

# TODO: Create a secondary bucket with versioning enabled
# Requirements:
# - Create another google_storage_bucket resource
# - Name it using var.secondary_bucket_name
# - Enable versioning using the versioning block
# - Add lifecycle rules specific to versioned objects:
#   1. Delete previous (non-current) versions after var.noncurrent_age_in_days
#   2. Keep only var.num_versions_to_keep newer versions

# TODO: (Optional) Create a bucket with conditional prefix-based rules
# Requirements:
# - Use count parameter based on var.create_prefix_bucket
# - Create a bucket with var.prefix_bucket_name
# - Add conditional lifecycle rules that apply only to objects with specific prefixes (e.g., "logs/", "tmp/")
# - Configure different retention policies for different prefixes 
