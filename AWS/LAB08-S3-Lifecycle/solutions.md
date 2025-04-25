# LAB08: S3 Bucket Lifecycle Management Solutions

This document provides solutions for the S3 Lifecycle Management lab. It's intended for instructor use and to help students who are stuck with specific tasks. 

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file:

```terraform
provider "aws" {
  region = var.region
}

# S3 bucket creation
resource "aws_s3_bucket" "lifecycle_demo" {
  bucket = var.bucket_name

  tags = {
    Name        = "S3 Lifecycle Demo"
    Environment = "Lab"
    Project     = "Terraform Training"
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

# Configure public access block settings
resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.lifecycle_demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rules" {
  bucket = aws_s3_bucket.lifecycle_demo.id
  
  # This is required when using versioning
  depends_on = [aws_s3_bucket_versioning.versioning]

  # Rule 1: Standard tier objects
  rule {
    id     = "standard-tier-transitions"
    status = "Enabled"

    filter {
      prefix = var.standard_prefix
    }

    # Move to Standard-IA after 30 days
    transition {
      days          = var.days_to_standard_ia
      storage_class = "STANDARD_IA"
    }

    # Move to Glacier after 60 days
    transition {
      days          = var.days_to_glacier
      storage_class = "GLACIER"
    }

    # Delete after 365 days
    expiration {
      days = var.days_to_expiration
    }
  }

  # Rule 2: Manage old versions
  rule {
    id     = "version-management"
    status = "Enabled"

    filter {
      prefix = ""
    }

    # Move old versions to Glacier after 30 days
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    # Delete old versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = var.days_to_delete_noncurrent
    }
  }

  # Rule 3: Manage incomplete multipart uploads
  rule {
    id     = "abort-incomplete-uploads"
    status = "Enabled"

    filter {
      prefix = ""
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Rule 4: Special configuration for logs
  rule {
    id     = "logs-management"
    status = "Enabled"

    filter {
      prefix = var.logs_prefix
    }

    # Move logs to Standard-IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Move logs to Glacier after 60 days
    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    # Delete logs after 180 days
    expiration {
      days = 180
    }
  }
}

# Create a bucket policy to deny non-HTTPS access
resource "aws_s3_bucket_policy" "secure_transport_policy" {
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

# Create folder prefixes
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

# Create a demo file for testing
resource "aws_s3_object" "demo_file" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.standard_prefix}/demo-file.txt"
  content = "This is a demo file created on ${timestamp()}"
}

# Create a second version of the demo file
resource "aws_s3_object" "demo_file_v2" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.standard_prefix}/demo-file.txt"
  content = "This is version 2 of the demo file, created on ${timestamp()}"
  
  depends_on = [aws_s3_object.demo_file]
}

# Add a log file for testing
resource "aws_s3_object" "log_file" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.logs_prefix}/sample-log.log"
  content = "Sample log entry at ${timestamp()}"
}

# Set up a CloudWatch metric alarm
resource "aws_cloudwatch_metric_alarm" "bucket_size_alarm" {
  alarm_name          = "${var.bucket_name}-size-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 86400  # 1 day
  statistic           = "Maximum"
  threshold           = var.storage_threshold
  alarm_description   = "Alarm when bucket size exceeds threshold"
  
  dimensions = {
    BucketName = aws_s3_bucket.lifecycle_demo.id
    StorageType = "StandardStorage"
  }
}
```

## Step-by-Step Explanation

### 1. S3 Bucket Creation

```terraform
resource "aws_s3_bucket" "lifecycle_demo" {
  bucket = var.bucket_name

  tags = {
    Name        = "S3 Lifecycle Demo"
    Environment = "Lab"
    Project     = "Terraform Training"
  }
}
```

This creates an S3 bucket with the specified name and tags. The tags help with organization and cost tracking.

### 2. Bucket Versioning

```terraform
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lifecycle_demo.id
  
  versioning_configuration {
    status = "Enabled"
  }
}
```

This enables versioning on the bucket, which allows multiple versions of an object to be kept in the same bucket.

### 3. Server-Side Encryption

```terraform
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.lifecycle_demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

This configures server-side encryption with AES256, ensuring all objects are encrypted at rest.

### 4. Public Access Block

```terraform
resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.lifecycle_demo.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

This blocks all public access to the bucket, which is a security best practice.

### 5. Lifecycle Rules

```terraform
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rules" {
  bucket = aws_s3_bucket.lifecycle_demo.id
  
  depends_on = [aws_s3_bucket_versioning.versioning]

  # Rule 1: Standard tier objects
  rule {
    id     = "standard-tier-transitions"
    status = "Enabled"

    filter {
      prefix = var.standard_prefix
    }

    transition {
      days          = var.days_to_standard_ia
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.days_to_glacier
      storage_class = "GLACIER"
    }

    expiration {
      days = var.days_to_expiration
    }
  }

  # Additional rules...
}
```

This sets up lifecycle rules that automatically transition objects between storage classes based on age and delete them after a certain period. The rules include:

- Moving standard files to Standard-IA after 30 days
- Moving standard files to Glacier after 60 days
- Deleting standard files after 365 days
- Managing old versions (transition to Glacier, then delete)
- Cleaning up incomplete multipart uploads
- Managing log files with their own lifecycle

### 6. Bucket Policy

```terraform
resource "aws_s3_bucket_policy" "secure_transport_policy" {
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
```

This creates a bucket policy that denies all actions when the connection is not using HTTPS, ensuring secure data transfer.

### 7. Folder Creation and Test Files

```terraform
resource "aws_s3_object" "standard_folder" {
  bucket  = aws_s3_bucket.lifecycle_demo.id
  key     = "${var.standard_prefix}/"
  content = ""
}

# Additional folders and test files...
```

This creates folder structures and sample files to demonstrate the lifecycle rules.

### 8. CloudWatch Metric Alarm

```terraform
resource "aws_cloudwatch_metric_alarm" "bucket_size_alarm" {
  alarm_name          = "${var.bucket_name}-size-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BucketSizeBytes"
  namespace           = "AWS/S3"
  period              = 86400  # 1 day
  statistic           = "Maximum"
  threshold           = var.storage_threshold
  alarm_description   = "Alarm when bucket size exceeds threshold"
  
  dimensions = {
    BucketName = aws_s3_bucket.lifecycle_demo.id
    StorageType = "StandardStorage"
  }
}
```

This creates a CloudWatch alarm to monitor the bucket size and alert when it exceeds the specified threshold.

## Testing the Solution

To test that your configuration works as expected, you can:

1. Deploy the infrastructure:
   ```bash
   terraform init
   terraform apply
   ```

2. Upload files to each prefix:
   ```bash
   # Create test files
   echo "Test standard file" > standard_test.txt
   echo "Test log file" > log_test.txt
   
   # Upload to appropriate folders
   aws s3 cp standard_test.txt s3://YOUR-BUCKET-NAME/standard/
   aws s3 cp log_test.txt s3://YOUR-BUCKET-NAME/logs/
   ```

3. Check versioning by modifying and re-uploading a file:
   ```bash
   echo "Updated content" > standard_test.txt
   aws s3 cp standard_test.txt s3://YOUR-BUCKET-NAME/standard/
   aws s3api list-object-versions --bucket YOUR-BUCKET-NAME --prefix standard/standard_test.txt
   ```

4. View lifecycle rules in the AWS console:
   - Navigate to S3 in the AWS console
   - Select your bucket
   - Go to the "Management" tab
   - View the lifecycle rules

5. Clean up when done:
   ```bash
   terraform destroy
   ```

## Common Troubleshooting Tips

1. **Bucket Name Conflicts**: If you get an error about the bucket name being taken, modify the bucket name in terraform.tfvars.

2. **Permissions Issues**: Make sure your AWS credentials have the necessary permissions to create S3 buckets and CloudWatch alarms.

3. **Lifecycle Rule Dependencies**: The lifecycle configuration depends on versioning being enabled. If you're seeing errors, check the dependencies.

4. **Policy Conflicts**: If you have existing bucket policies, make sure they don't conflict with the one being applied.

5. **Testing Lifecycle Rules**: Remember that lifecycle rules are applied by AWS asynchronously, typically within 24 hours. You won't see immediate transitions when testing. 