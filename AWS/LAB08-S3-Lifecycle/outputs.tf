output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.lifecycle_demo.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.lifecycle_demo.arn
}

output "bucket_region" {
  description = "Region of the created S3 bucket"
  value       = aws_s3_bucket.lifecycle_demo.region
}

output "versioning_status" {
  description = "Current versioning status of the bucket"
  value       = aws_s3_bucket_versioning.versioning.versioning_configuration[0].status
}

output "lifecycle_rules" {
  description = "List of configured lifecycle rule IDs"
  value = [
    for rule in aws_s3_bucket_lifecycle_configuration.lifecycle_rules.rule : rule.id
  ]
}

output "standard_folder_path" {
  description = "S3 path for standard objects"
  value       = "s3://${aws_s3_bucket.lifecycle_demo.id}/${var.standard_prefix}/"
}

output "logs_folder_path" {
  description = "S3 path for logs objects"
  value       = "s3://${aws_s3_bucket.lifecycle_demo.id}/${var.logs_prefix}/"
}

output "archive_folder_path" {
  description = "S3 path for archive objects"
  value       = "s3://${aws_s3_bucket.lifecycle_demo.id}/${var.archive_prefix}/"
}

output "aws_cli_list_objects" {
  description = "AWS CLI command to list objects in the bucket"
  value       = "aws s3 ls s3://${aws_s3_bucket.lifecycle_demo.id} --recursive"
}

output "aws_cli_list_versions" {
  description = "AWS CLI command to list object versions"
  value       = "aws s3api list-object-versions --bucket ${aws_s3_bucket.lifecycle_demo.id}"
}

output "aws_cli_upload_file" {
  description = "AWS CLI command to upload a file to test lifecycle rules"
  value       = "aws s3 cp example.txt s3://${aws_s3_bucket.lifecycle_demo.id}/${var.standard_prefix}/"
}

output "s3_console_url" {
  description = "URL to view this bucket in the AWS console"
  value       = "https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.lifecycle_demo.id}?region=${var.region}&tab=objects"
} 
