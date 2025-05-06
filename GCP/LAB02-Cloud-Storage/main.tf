provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Create a Cloud Storage bucket
# Requirements:
# - Use var.bucket_name for the bucket name
# - Set the location using var.location
# - Set the storage class using var.storage_class
# - Set uniform bucket level access to true
# - Configure versioning based on var.enable_versioning
# - Add project and environment labels

# TODO: (Optional) Configure website hosting if var.enable_website is true
# Requirements: 
# - Use count or dynamic blocks to conditionally add this configuration
# - Set main_page_suffix to "index.html"
# - Set not_found_page to "404.html"

# TODO: (Optional) Configure lifecycle rules if var.enable_lifecycle_rules is true
# Requirements:
# - Use count or dynamic blocks to conditionally add this configuration
# - Create a rule to delete objects older than var.lifecycle_age_days days 
