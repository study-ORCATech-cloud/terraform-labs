provider "aws" {
  region = var.region
}

# Create an S3 bucket with versioning and lifecycle rules
resource "aws_s3_bucket" "lifecycle_demo" {
  bucket = var.bucket_name

  tags = {
    Name        = "S3 Lifecycle Demo Bucket"
    Environment = "Lab"
    Project     = "Terraform-Labs"
  }
}

# Configure bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lifecycle_demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.lifecycle_demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Configure public access block (block all public access)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.lifecycle_demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure lifecycle rules for standard tier objects
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rules" {
  bucket = aws_s3_bucket.lifecycle_demo.id

  # Rule 1: Transition standard tier objects to Standard-IA after 30 days
  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"

    filter {
      prefix = var.standard_prefix
    }

    transition {
      days          = var.days_to_standard_ia
      storage_class = "STANDARD_IA"
    }
  }

  # Rule 2: Transition standard objects to Glacier after 60 days
  rule {
    id     = "transition-to-glacier"
    status = "Enabled"

    filter {
      prefix = var.standard_prefix
    }

    transition {
      days          = var.days_to_glacier
      storage_class = "GLACIER"
    }

    # Optional: Delete objects after 365 days
    expiration {
      days = var.days_to_expiration
    }
  }

  # Rule 3: Manage old versions
  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {
      prefix = ""
    }

    # Delete non-current versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = var.days_to_delete_noncurrent
    }

    # Add a transition for non-current versions to Glacier after 30 days
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }
  }

  # Rule 4: Manage incomplete multipart uploads
  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Rule 5: Special configuration for logs
  rule {
    id     = "logs-management"
    status = "Enabled"

    filter {
      prefix = var.logs_prefix
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 180 # Delete logs after 180 days
    }
  }
}

# Create a bucket policy to deny non-HTTPS access
resource "aws_s3_bucket_policy" "secure_transport" {
  bucket = aws_s3_bucket.lifecycle_demo.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyNonSecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.lifecycle_demo.arn,
          "${aws_s3_bucket.lifecycle_demo.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# Optional: Create folders (prefixes) in the bucket
resource "aws_s3_object" "standard_folder" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.standard_prefix}/"
  content = ""
}

resource "aws_s3_object" "logs_folder" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.logs_prefix}/"
  content = ""
}

resource "aws_s3_object" "archive_folder" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.archive_prefix}/"
  content = ""
}

# Create a custom demo file for testing
resource "aws_s3_object" "demo_file" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.standard_prefix}/demo-file.txt"
  content = "This is a demo file to test S3 lifecycle rules. Created by Terraform on ${timestamp()}"
}

# Create different versions of the same file to demonstrate versioning
resource "aws_s3_object" "demo_file_v2" {
  bucket     = aws_s3_bucket.lifecycle_demo.id
  key        = "${var.standard_prefix}/demo-file.txt"
  content    = "This is version 2 of the demo file. Created by Terraform on ${timestamp()}"
  depends_on = [aws_s3_object.demo_file]
}

# Add a log file to demonstrate lifecycle rules on logs
resource "aws_s3_object" "log_file" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.logs_prefix}/sample-log.txt"
  content = "Sample log entry for testing lifecycle rules. Generated on ${timestamp()}"
}

# CloudWatch Event Rule to check for objects nearing transition
resource "aws_cloudwatch_metric_alarm" "storage_metrics" {
  alarm_name          = "s3-storage-metrics"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 86400 # 1 day
  statistic           = "Maximum"
  threshold           = var.storage_threshold
  alarm_description   = "Alarm when bucket size exceeds the threshold"

  dimensions = {
    BucketName  = aws_s3_bucket.lifecycle_demo.id
    StorageType = "StandardStorage"
  }
} 
