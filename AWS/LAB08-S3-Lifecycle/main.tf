provider "aws" {
  region = var.region
}

# TODO: Create an S3 bucket with versioning and lifecycle rules
# Requirements:
# - Use the bucket name from var.bucket_name 
# - Add appropriate tags (Name, Environment, Project)
# - The bucket must be created before you can configure its properties

# TODO: Configure bucket versioning
# Requirements:
# - Enable versioning on the bucket you created above
# - Remember to reference the bucket id correctly

# TODO: Configure server-side encryption
# Requirements:
# - Apply server-side encryption using AES256 algorithm
# - This provides at-rest encryption for all objects in the bucket

# TODO: Configure public access block to secure the bucket
# Requirements:
# - Block all public access to the bucket using the aws_s3_bucket_public_access_block resource
# - Set all block_public_* and restrict_public_* properties to true

# TODO: Configure lifecycle rules for standard tier objects
# Requirements:
# - Create an aws_s3_bucket_lifecycle_configuration resource
# - Implement the following rules:

# Rule 1: Transition standard tier objects to Standard-IA after 30 days
# - Set appropriate ID and Enabled status
# - Use var.standard_prefix for the filter prefix
# - Set transition days using var.days_to_standard_ia
# - Target storage class should be "STANDARD_IA"

# Rule 2: Transition standard objects to Glacier after 60 days
# - Set appropriate ID and Enabled status
# - Use var.standard_prefix for the filter prefix
# - Set transition days using var.days_to_glacier
# - Target storage class should be "GLACIER"
# - Optionally configure expiration after var.days_to_expiration days

# Rule 3: Manage old versions
# - Set appropriate ID and Enabled status
# - Use empty prefix to apply to all objects
# - Configure noncurrent_version_expiration after var.days_to_delete_noncurrent days
# - Add a transition for non-current versions to Glacier after 30 days

# Rule 4: Manage incomplete multipart uploads
# - Set appropriate ID and Enabled status
# - Use empty prefix to apply to all objects
# - Configure abort_incomplete_multipart_upload after 7 days

# Rule 5: Special configuration for logs
# - Set appropriate ID and Enabled status
# - Use var.logs_prefix for the filter prefix
# - Add transition to STANDARD_IA after 30 days
# - Add transition to GLACIER after 60 days
# - Add expiration after 180 days

# TODO: Create a bucket policy to deny non-HTTPS access
# Requirements:
# - Use the aws_s3_bucket_policy resource
# - Create a policy that denies all S3 actions when aws:SecureTransport is false
# - Apply the policy to both the bucket itself and all objects inside it
# - Use the jsonencode function to create the policy document

# TODO: Create folder prefixes in the bucket
# Requirements:
# - Create empty objects with keys ending in "/" to represent folders
# - Create folders for standard, logs, and archive prefixes

# TODO: Create a demo file for testing
# Requirements:
# - Create a sample file in the standard prefix
# - Add a timestamp to the content to show when it was created

# TODO: Create a second version of the demo file
# Requirements:
# - Use the same key as the demo file, but with updated content
# - Make sure this depends on the first demo file
# - This will demonstrate how versioning works

# TODO: Add a log file for testing
# Requirements:
# - Create a sample log file in the logs prefix
# - This will help demonstrate the logs lifecycle rule

# TODO: Set up a CloudWatch metric alarm
# Requirements:
# - Monitor the BucketSizeBytes metric
# - Set appropriate alarm conditions (period, evaluation_periods, etc.)
# - Set a threshold from var.storage_threshold
