output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.lab02_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.lab02_bucket.arn
}

output "bucket_domain_name" {
  description = "The domain name of the bucket"
  value       = aws_s3_bucket.lab02_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the bucket"
  value       = aws_s3_bucket.lab02_bucket.bucket_regional_domain_name
}

output "website_endpoint" {
  description = "The website endpoint of the bucket (only available if static website hosting is enabled)"
  value       = var.enable_static_website ? aws_s3_bucket_website_configuration.lab02_website[0].website_endpoint : null
}

output "website_domain" {
  description = "The domain of the website endpoint (only available if static website hosting is enabled)"
  value       = var.enable_static_website ? aws_s3_bucket_website_configuration.lab02_website[0].website_domain : null
}

output "website_url" {
  description = "The full URL to access the static website (only available if static website hosting is enabled)"
  value       = var.enable_static_website ? "http://${aws_s3_bucket_website_configuration.lab02_website[0].website_endpoint}" : null
}

output "versioning_status" {
  description = "The versioning status of the bucket"
  value       = var.versioning_enabled ? "Enabled" : "Suspended"
}
