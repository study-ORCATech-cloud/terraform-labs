provider "aws" {
  region = var.aws_region
}

# Create an S3 bucket with versioning enabled
resource "aws_s3_bucket" "lab02_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Lab         = "LAB02-S3-Bucket"
  }
}

# Add versioning configuration
resource "aws_s3_bucket_versioning" "lab02_bucket_versioning" {
  bucket = aws_s3_bucket.lab02_bucket.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Configure bucket ownership
resource "aws_s3_bucket_ownership_controls" "lab02_bucket_ownership" {
  bucket = aws_s3_bucket.lab02_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure public access block settings
resource "aws_s3_bucket_public_access_block" "lab02_public_access" {
  bucket                  = aws_s3_bucket.lab02_bucket.id
  block_public_acls       = !var.allow_public_access
  block_public_policy     = !var.allow_public_access
  ignore_public_acls      = !var.allow_public_access
  restrict_public_buckets = !var.allow_public_access
}

# Configure ACLs (only applied when public access is allowed)
resource "aws_s3_bucket_acl" "lab02_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.lab02_bucket_ownership,
    aws_s3_bucket_public_access_block.lab02_public_access,
  ]

  bucket = aws_s3_bucket.lab02_bucket.id
  acl    = var.allow_public_access ? "public-read" : "private"
}

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
