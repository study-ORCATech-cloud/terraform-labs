# LAB02: Creating and Managing an S3 Bucket with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to create and manage an **Amazon S3 bucket**. You'll configure key S3 features including versioning, access policies, and optionally set up static website hosting. This lab demonstrates how infrastructure as code can simplify storage provisioning and management in AWS.

Amazon S3 (Simple Storage Service) is a scalable object storage service that can store and retrieve any amount of data from anywhere on the web. It's commonly used for backup and storage, hosting static websites, storing application assets, data lakes, and more.

---

## 🎯 Learning Objectives

- Create and configure an S3 bucket using Terraform
- Implement S3 bucket versioning for data protection
- Configure bucket ownership and access control settings
- Create and apply bucket policies for secure access
- Set up static website hosting with custom HTML pages
- Learn to properly clean up cloud resources to avoid unnecessary charges

---

## 🧰 Prerequisites

- AWS account with appropriate permissions
- AWS CLI installed and configured with access credentials
- Terraform v1.3+ installed
- Basic understanding of S3 concepts

---

## 📁 Files Structure

```
AWS/LAB02-S3-Bucket/
├── main.tf                  # Main configuration file with S3 bucket resources
├── variables.tf             # Variable declarations 
├── outputs.tf               # Output definitions
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
└── README.md                # Lab instructions
```

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB02-S3-Bucket
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure Bucket Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit the `terraform.tfvars` file to customize your deployment:
   ```bash
   # The S3 bucket name must be globally unique across all AWS accounts
   bucket_name = "your-name-terraform-lab02-bucket"
   
   # Uncomment these lines if you want to enable static website hosting
   # allow_public_access = true
   # enable_static_website = true
   ```

   > ⚠️ **Important**: S3 bucket names must be globally unique across all AWS accounts. Choose a name that is unlikely to be taken.

### Step 4: Complete the TODO Sections

This lab contains several TODO sections that you need to complete:

1. In `main.tf`:
   - Create the S3 bucket with appropriate tags
   - Configure bucket versioning based on variables
   - Configure bucket ownership controls
   - Configure public access block settings
   - Configure bucket ACL (Access Control List)
   - Set up static website hosting (conditional resource)
   - Create a bucket policy for public access (conditional resource)
   - Upload index.html and error.html files for the website (conditional resources)

2. In `outputs.tf`:
   - Define outputs for bucket ID, ARN, domain names
   - Create conditional outputs for website endpoints
   - Output versioning status

### Step 5: Review the Execution Plan

1. Generate and review the execution plan:
   ```bash
   terraform plan
   ```

2. Verify the resources to be created:
   - S3 bucket with your specified name
   - Versioning configuration
   - Ownership controls and public access settings
   - Access control lists (ACLs)
   - Website configuration and HTML files (if enabled)
   - Bucket policy (if public access is enabled)

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful creation, Terraform will display outputs including:
   - Bucket ID (name)
   - Bucket ARN
   - Bucket domain names
   - Website URL (if enabled)
   - Versioning status

### Step 7: Explore Bucket Features

1. List the created bucket:
   ```bash
   aws s3 ls
   ```

2. If you enabled website hosting, access the website URL from the output:
   ```
   http://<bucket-name>.s3-website.<region>.amazonaws.com
   ```

3. Test uploading a file to your bucket:
   ```bash
   echo "Hello, S3!" > hello.txt
   aws s3 cp hello.txt s3://your-name-terraform-lab02-bucket/
   ```

4. List bucket contents:
   ```bash
   aws s3 ls s3://your-name-terraform-lab02-bucket/
   ```

5. Test versioning by uploading the same file again with different content:
   ```bash
   echo "Hello again, S3!" > hello.txt
   aws s3 cp hello.txt s3://your-name-terraform-lab02-bucket/
   ```

6. List object versions:
   ```bash
   aws s3api list-object-versions --bucket your-name-terraform-lab02-bucket
   ```

---

## 🔍 Understanding the Code

### Main Resources

1. **aws_s3_bucket** - Creates the basic S3 bucket:
   ```hcl
   resource "aws_s3_bucket" "lab02_bucket" {
     bucket = var.bucket_name
     tags = {
       Name        = var.bucket_name
       Environment = var.environment
       Lab         = "LAB02-S3-Bucket"
     }
   }
   ```

2. **aws_s3_bucket_versioning** - Controls versioning settings:
   ```hcl
   resource "aws_s3_bucket_versioning" "lab02_bucket_versioning" {
     bucket = aws_s3_bucket.lab02_bucket.id
     versioning_configuration {
       status = var.versioning_enabled ? "Enabled" : "Suspended"
     }
   }
   ```

3. **aws_s3_bucket_ownership_controls** - Sets object ownership:
   ```hcl
   resource "aws_s3_bucket_ownership_controls" "lab02_ownership" {
     bucket = aws_s3_bucket.lab02_bucket.id
     rule {
       object_ownership = "BucketOwnerPreferred"
     }
   }
   ```

4. **aws_s3_bucket_public_access_block** - Controls public access settings:
   ```hcl
   resource "aws_s3_bucket_public_access_block" "lab02_public_access" {
     bucket = aws_s3_bucket.lab02_bucket.id
     block_public_acls       = !var.allow_public_access
     block_public_policy     = !var.allow_public_access
     ignore_public_acls      = !var.allow_public_access
     restrict_public_buckets = !var.allow_public_access
   }
   ```

5. **aws_s3_bucket_website_configuration** - Configures static website hosting:
   ```hcl
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

6. **aws_s3_bucket_policy** - Sets permissions for public access:
   ```hcl
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
     depends_on = [aws_s3_bucket_public_access_block.lab02_public_access]
   }
   ```

7. **aws_s3_object** - Creates website files:
   ```hcl
   resource "aws_s3_object" "index_html" {
     count         = var.enable_static_website ? 1 : 0
     bucket        = aws_s3_bucket.lab02_bucket.id
     key           = "index.html"
     content       = <<-EOT
       <!DOCTYPE html>
       <html>
         <head>
           <title>S3 Website - Success!</title>
         </head>
         <body>
           <h1>Congratulations! Your S3 website is working!</h1>
           <p>Created with Terraform</p>
         </body>
       </html>
     EOT
     content_type  = "text/html"
   }
   ```

---

## 💡 Key Learning Points

1. **S3 Bucket Creation** - Learning to provision cloud storage programmatically
2. **Versioning** - Understanding how to protect data with object versioning
3. **Access Controls** - Managing who can access your bucket and its contents
4. **Object Ownership** - Controlling how object ownership is handled
5. **Public Access Blocks** - Using preventative controls to secure S3 resources
6. **Static Website** - Setting up S3 for static content hosting
7. **Bucket Policies** - Using IAM policies for fine-grained access control
8. **Conditional Resources** - Using Terraform's count parameter for optional resources
9. **Resource Dependencies** - Understanding how Terraform manages resource creation order

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Object Lifecycle Rules** - Add a lifecycle rule to transition older objects to Glacier storage
   ```hcl
   resource "aws_s3_bucket_lifecycle_configuration" "example" {
     bucket = aws_s3_bucket.lab02_bucket.id
     rule {
       id     = "archive-rule"
       status = "Enabled"
       transition {
         days          = 30
         storage_class = "GLACIER"
       }
     }
   }
   ```

2. **Server-Side Encryption** - Enable default encryption for the bucket
   ```hcl
   resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
     bucket = aws_s3_bucket.lab02_bucket.id
     rule {
       apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
       }
     }
   }
   ```

3. **CORS Configuration** - Add a CORS configuration to allow cross-origin requests
   ```hcl
   resource "aws_s3_bucket_cors_configuration" "example" {
     bucket = aws_s3_bucket.lab02_bucket.id
     cors_rule {
       allowed_headers = ["*"]
       allowed_methods = ["GET"]
       allowed_origins = ["https://example.com"]
       max_age_seconds = 3000
     }
   }
   ```

4. **Event Notifications** - Configure S3 event notifications to trigger Lambda or SNS
   ```hcl
   resource "aws_s3_bucket_notification" "example" {
     bucket = aws_s3_bucket.lab02_bucket.id
     topic {
       topic_arn     = aws_sns_topic.example.arn
       events        = ["s3:ObjectCreated:*"]
       filter_suffix = ".jpg"
     }
   }
   ```

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. First, empty the bucket (required before deletion):
   ```bash
   aws s3 rm s3://your-name-terraform-lab02-bucket/ --recursive
   ```

   > ⚠️ **Note**: If versioning is enabled, you need to delete all versions of objects:
   ```bash
   aws s3api delete-objects --bucket your-name-terraform-lab02-bucket \
     --delete "$(aws s3api list-object-versions --bucket your-name-terraform-lab02-bucket \
     --output json --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"
   ```

2. Use Terraform to destroy all resources:
   ```bash
   terraform destroy
   ```

3. Type `yes` when prompted

4. Verify in the AWS Console that the bucket has been deleted:
   - Navigate to S3 in the AWS Console
   - Confirm that your bucket no longer exists

5. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars
   ```

> ⚠️ **Important**: Always remember to empty and delete your S3 buckets when you're done to avoid unexpected charges on your AWS account.

---

## 🚫 Common Errors and Troubleshooting

1. **Bucket Name Already Exists**:
   ```
   Error: Error creating S3 bucket: BucketAlreadyExists: The requested bucket name is not available
   ```
   **Solution**: Choose a different, globally unique bucket name in your terraform.tfvars file.

2. **Access Denied**:
   ```
   Error: Access Denied when attempting to create bucket
   ```
   **Solution**: Verify your AWS credentials have the necessary permissions to create S3 resources.

3. **Policy Conflicts**:
   ```
   Error: Error putting S3 policy: InvalidBucketPolicy: Policy has invalid resource
   ```
   **Solution**: Ensure your bucket policy references the correct bucket ARN and follows AWS policy syntax.

4. **Public Access Blocks Preventing Website Access**:
   ```
   Error: AccessDenied when accessing website endpoint
   ```
   **Solution**: Ensure both allow_public_access is set to true and public access blocks are properly configured.

---

## 📚 Additional Resources

- [Terraform AWS S3 Bucket Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [S3 Static Website Hosting Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteHosting.html)
- [S3 Bucket Versioning Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
- [S3 Access Control Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-overview.html)
- [S3 Bucket Policy Examples](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html)

---

## 🚀 Next Lab

Proceed to [LAB03-IAM](../LAB03-IAM/) to learn how to provision and manage IAM users, groups, and policies using Terraform.

---

Happy Terraforming!