# TODO: Define an output for bucket_name
# Requirements:
# - Name it "bucket_name"
# - Description should be "Name of the created S3 bucket"
# - Value should be the ID of the S3 bucket you created
# HINT: Use aws_s3_bucket.lifecycle_demo.id

# TODO: Define an output for bucket_arn
# Requirements:
# - Name it "bucket_arn"
# - Description should be "ARN of the created S3 bucket"
# - Value should be the ARN of the S3 bucket you created
# HINT: Use aws_s3_bucket.lifecycle_demo.arn

# TODO: Define an output for bucket_region
# Requirements:
# - Name it "bucket_region"
# - Description should be "Region of the created S3 bucket"
# - Value should be the region of the S3 bucket you created
# HINT: Use aws_s3_bucket.lifecycle_demo.region

# TODO: Define an output for versioning_status
# Requirements:
# - Name it "versioning_status"
# - Description should be "Current versioning status of the bucket"
# - Value should be the versioning status configuration
# HINT: Use aws_s3_bucket_versioning.versioning.versioning_configuration[0].status

# TODO: Define an output for lifecycle_rules
# Requirements:
# - Name it "lifecycle_rules"
# - Description should be "List of configured lifecycle rule IDs"
# - Value should be a list of all lifecycle rule IDs
# HINT: Use a for loop to iterate through aws_s3_bucket_lifecycle_configuration.lifecycle_rules.rule

# TODO: Define an output for standard_folder_path
# Requirements:
# - Name it "standard_folder_path"
# - Description should be "S3 path for standard objects"
# - Value should be the S3 URI for the standard prefix
# HINT: Use "s3://${aws_s3_bucket.lifecycle_demo.id}/${var.standard_prefix}/"

# TODO: Define an output for logs_folder_path
# Requirements:
# - Name it "logs_folder_path"
# - Description should be "S3 path for logs objects"
# - Value should be the S3 URI for the logs prefix
# HINT: Use "s3://${aws_s3_bucket.lifecycle_demo.id}/${var.logs_prefix}/"

# TODO: Define an output for archive_folder_path
# Requirements:
# - Name it "archive_folder_path"
# - Description should be "S3 path for archive objects"
# - Value should be the S3 URI for the archive prefix
# HINT: Use "s3://${aws_s3_bucket.lifecycle_demo.id}/${var.archive_prefix}/"

# TODO: Define an output for aws_cli_list_objects
# Requirements:
# - Name it "aws_cli_list_objects"
# - Description should be "AWS CLI command to list objects in the bucket"
# - Value should be the AWS CLI command to list all objects recursively
# HINT: Use "aws s3 ls s3://${aws_s3_bucket.lifecycle_demo.id} --recursive"

# TODO: Define an output for aws_cli_list_versions
# Requirements:
# - Name it "aws_cli_list_versions"
# - Description should be "AWS CLI command to list object versions"
# - Value should be the AWS CLI command to list all object versions
# HINT: Use "aws s3api list-object-versions --bucket ${aws_s3_bucket.lifecycle_demo.id}"

# TODO: Define an output for aws_cli_upload_file
# Requirements:
# - Name it "aws_cli_upload_file"
# - Description should be "AWS CLI command to upload a file to test lifecycle rules"
# - Value should be the AWS CLI command to upload a file to the standard prefix
# HINT: Use "aws s3 cp example.txt s3://${aws_s3_bucket.lifecycle_demo.id}/${var.standard_prefix}/"

# TODO: Define an output for s3_console_url
# Requirements:
# - Name it "s3_console_url"
# - Description should be "URL to view this bucket in the AWS console"
# - Value should be the AWS console URL for this bucket
# HINT: Use "https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.lifecycle_demo.id}?region=${var.aws_region}&tab=objects"
