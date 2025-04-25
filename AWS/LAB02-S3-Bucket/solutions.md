# LAB02: S3 Bucket - Solutions

This document contains solutions to the TODOs in the main.tf and outputs.tf files for LAB02.

## Solutions for main.tf

### Solution: Create an S3 Bucket

```hcl
# Create an S3 bucket with versioning enabled
resource "aws_s3_bucket" "lab02_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Lab         = "LAB02-S3-Bucket"
  }
}
```

### Solution: Configure Bucket Versioning

```hcl
# Add versioning configuration
resource "aws_s3_bucket_versioning" "lab02_bucket_versioning" {
  bucket = aws_s3_bucket.lab02_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}
```

### Solution: Configure Bucket Ownership

```hcl
# Configure bucket ownership
resource "aws_s3_bucket_ownership_controls" "lab02_bucket_ownership" {
  bucket = aws_s3_bucket.lab02_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
```

### Solution: Configure Public Access Block Settings

```hcl
# Configure public access block settings
resource "aws_s3_bucket_public_access_block" "lab02_public_access" {
  bucket                  = aws_s3_bucket.lab02_bucket.id
  block_public_acls       = !var.allow_public_access
  block_public_policy     = !var.allow_public_access
  ignore_public_acls      = !var.allow_public_access
  restrict_public_buckets = !var.allow_public_access
}
```

### Solution: Configure Bucket ACL

```hcl
# Configure ACLs (only applied when public access is allowed)
resource "aws_s3_bucket_acl" "lab02_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.lab02_bucket_ownership,
    aws_s3_bucket_public_access_block.lab02_public_access,
  ]

  bucket = aws_s3_bucket.lab02_bucket.id
  acl    = var.allow_public_access ? "public-read" : "private"
}
```

### Solution: Configure Static Website Hosting

```hcl
# Enable static website hosting if specified
resource "aws_s3_bucket_website_configuration" "lab02_website" {
  count  = var.enable_static_website ? 1 : 0
  bucket = aws_s3_bucket.lab02_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
```

### Solution: Add Bucket Policy for Public Access

```hcl
# Add bucket policy for public access when website hosting is enabled
resource "aws_s3_bucket_policy" "lab02_bucket_policy" {
  count  = var.enable_static_website && var.allow_public_access ? 1 : 0
  bucket = aws_s3_bucket.lab02_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.lab02_bucket.arn}/*"
      },
    ]
  })

  depends_on = [
    aws_s3_bucket_public_access_block.lab02_public_access
  ]
}
```

### Solution: Upload Index HTML File

```hcl
# Optionally upload example files for website hosting
resource "aws_s3_object" "lab02_index_html" {
  count        = var.enable_static_website ? 1 : 0
  bucket       = aws_s3_bucket.lab02_bucket.id
  key          = "index.html"
  content      = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Terraform S3 Lab Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        h1 {
            color: #0066cc;
        }
        .success {
            padding: 20px;
            background-color: #e6f7ff;
            border-left: 5px solid #0066cc;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="success">
        <h1>Success! Your S3 Website is Live</h1>
        <p>This page was created through Terraform as part of LAB02-S3-Bucket.</p>
    </div>
    <h2>What You've Accomplished:</h2>
    <ul>
        <li>Created an S3 bucket with Terraform</li>
        <li>Configured proper bucket settings</li>
        <li>Enabled static website hosting</li>
        <li>Uploaded this index.html file</li>
    </ul>
    <p>Timestamp: ${timestamp()}</p>
</body>
</html>
EOF
  content_type = "text/html"
}
```

### Solution: Upload Error HTML File

```hcl
resource "aws_s3_object" "lab02_error_html" {
  count        = var.enable_static_website ? 1 : 0
  bucket       = aws_s3_bucket.lab02_bucket.id
  key          = "error.html"
  content      = <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Error - Terraform S3 Lab</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        h1 {
            color: #cc0000;
        }
        .error {
            padding: 20px;
            background-color: #ffebe6;
            border-left: 5px solid #cc0000;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="error">
        <h1>Error 404 - Page Not Found</h1>
        <p>The requested file was not found in this S3 bucket.</p>
    </div>
    <p>Return to <a href="/index.html">home page</a>.</p>
</body>
</html>
EOF
  content_type = "text/html"
}
```

## Solutions for outputs.tf

### Solution: Bucket ID Output

```hcl
output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.lab02_bucket.id
}
```

### Solution: Bucket ARN Output

```hcl
output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.lab02_bucket.arn
}
```

### Solution: Bucket Domain Name Output

```hcl
output "bucket_domain_name" {
  description = "The domain name of the bucket"
  value       = aws_s3_bucket.lab02_bucket.bucket_domain_name
}
```

### Solution: Bucket Regional Domain Name Output

```hcl
output "bucket_regional_domain_name" {
  description = "The regional domain name of the bucket"
  value       = aws_s3_bucket.lab02_bucket.bucket_regional_domain_name
}
```

### Solution: Website Endpoint Output

```hcl
output "website_endpoint" {
  description = "The website endpoint of the bucket (only available if static website hosting is enabled)"
  value       = var.enable_static_website ? aws_s3_bucket_website_configuration.lab02_website[0].website_endpoint : null
}
```

### Solution: Website Domain Output

```hcl
output "website_domain" {
  description = "The domain of the website endpoint (only available if static website hosting is enabled)"
  value       = var.enable_static_website ? aws_s3_bucket_website_configuration.lab02_website[0].website_domain : null
}
```

### Solution: Website URL Output

```hcl
output "website_url" {
  description = "The full URL to access the static website (only available if static website hosting is enabled)"
  value       = var.enable_static_website ? "http://${aws_s3_bucket_website_configuration.lab02_website[0].website_endpoint}" : null
}
```

### Solution: Versioning Status Output

```hcl
output "versioning_status" {
  description = "The versioning status of the bucket"
  value       = var.versioning_enabled ? "Enabled" : "Suspended"
}
```

## Explanation

### S3 Bucket
- We create a simple S3 bucket with the provided name and add tags for identification.
- S3 bucket names must be globally unique across all AWS accounts.

### Bucket Versioning
- We enable or suspend versioning based on the boolean variable.
- Versioning allows you to recover from unintended deletes or overwrites.

### Bucket Ownership
- We set "BucketOwnerPreferred" to ensure objects uploaded to the bucket are owned by the bucket owner.
- This is important for access control and ACL settings.

### Public Access Block
- We configure public access settings based on the allow_public_access variable.
- We negate the variable because block_public_* settings expect the opposite boolean value.

### Bucket ACL
- We set the ACL to either "public-read" (for public websites) or "private" (for private buckets).
- The depends_on ensures proper order of operations, as ACLs require ownership settings.

### Static Website Hosting
- We conditionally enable static website hosting using the count parameter.
- We configure index and error documents for a complete website setup.

### Bucket Policy
- We add a policy to allow public read access specifically for static websites.
- This only applies when both website hosting and public access are enabled.
- The policy is specified using the jsonencode function to create a proper JSON policy document.

### HTML Objects
- We upload index.html and error.html files using heredoc syntax.
- These files are only created when static website hosting is enabled.
- We set the proper content type for browser rendering.

### Outputs
- We use outputs to expose important information about our created resources.
- Some outputs are conditional and only provide values when certain features are enabled.
- The website_url output combines other values to create a convenient access URL.

## Testing
After implementing these solutions and running `terraform apply`, you should:
1. Verify the S3 bucket is created with the correct settings
2. If website hosting is enabled, visit the website_url to see the website
3. Test error handling by visiting a non-existent path
4. Verify versioning is working by uploading multiple versions of a file

## Notes
- Remember that S3 bucket names must be globally unique
- Public bucket access should only be enabled in specific scenarios like static websites
- In production, consider adding additional security measures like CORS, server-side encryption, and access logging 