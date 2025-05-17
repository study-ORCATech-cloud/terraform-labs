# LAB08: Advanced S3 Bucket Lifecycle Management and Versioning with Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll implement **Amazon S3 bucket lifecycle policies** and **object versioning** using **Terraform**. You'll create a bucket with multiple storage tiers, automated transitions between storage classes, expiration rules, and versioning to protect against accidental deletions. These features help optimize storage costs while maintaining data durability and accessibility for different access patterns.

---

## 🎯 Learning Objectives

- Create an S3 bucket with server-side encryption and security controls
- Enable object versioning to maintain multiple versions of objects
- Configure lifecycle rules to automatically transition objects between storage classes
- Set up expiration rules to automatically delete old objects and versions
- Monitor S3 bucket metrics using CloudWatch
- Test and validate lifecycle policies and versioning behavior

---

## 🧰 Prerequisites

- AWS account with S3 permissions
- Terraform v1.3+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of S3 storage classes and pricing models

---

## 📁 Files Structure

```
AWS/LAB08-S3-Lifecycle/
├── main.tf                  # S3 bucket, versioning, and lifecycle configurations with TODOs
├── variables.tf             # Variable definitions for customization
├── outputs.tf               # Output definitions with TODOs
├── providers.tf             # AWS provider configuration
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
├── solutions.md             # Solutions to the TODOs (for reference)
└── README.md                # This documentation file
```

---

## 🌐 S3 Lifecycle Architecture

This lab implements a comprehensive S3 storage management strategy with the following components:

1. **S3 Bucket**: Core storage container with versioning enabled
2. **Storage Classes**: Multiple tiers including Standard, Standard-IA, and Glacier
3. **Lifecycle Rules**: Automated policies that transition and expire objects
4. **Versioning**: System to maintain multiple versions of objects
5. **Prefix-Based Management**: Different lifecycle rules for different object paths
6. **Server-Side Encryption**: At-rest data protection
7. **Security Controls**: Bucket policies to enforce HTTPS
8. **CloudWatch Monitoring**: Storage size monitoring and alerting

All of these features work together to create a cost-effective, secure, and automated storage solution.

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
   cd AWS/LAB08-S3-Lifecycle
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure S3 Bucket Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Customize the configuration in `terraform.tfvars` to adjust:
   - Bucket name (must be globally unique)
   - Storage prefix paths
   - Lifecycle transition days
   - Expiration periods
   - CloudWatch alarm threshold

   > ⚠️ **Important**: S3 bucket names must be globally unique across all AWS accounts. Choose a name that is unlikely to conflict with existing buckets.

### Step 4: Complete the TODO Sections

This lab contains several TODO sections in main.tf and outputs.tf that you need to complete:

1. In `main.tf`:

   a. **S3 Bucket Creation**
      - Create the S3 bucket with appropriate tags
      - Configure versioning on the bucket
      - Set up server-side encryption using AES256
      - Configure public access block settings for security

   b. **Lifecycle Rules Configuration**
      - Create standard tier transition rules (Standard → Standard-IA → Glacier)
      - Configure version management rules
      - Set up incomplete multipart upload cleanup
      - Create specialized rules for log files
      - Set appropriate expiration periods for all object types

   c. **Security Configuration**
      - Create a bucket policy to enforce HTTPS access
      - Use the jsonencode function to create the policy document
      - Apply the policy to both the bucket and all objects inside it

   d. **Folder Structure and Test Files**
      - Create folder prefixes for different object types
      - Add sample files for testing lifecycle rules
      - Create multiple versions of the same object to test versioning

   e. **Monitoring Setup**
      - Configure a CloudWatch alarm to monitor bucket size
      - Set appropriate thresholds and alarm actions

2. In `outputs.tf`:
   - Define outputs for bucket identifiers (name, ARN, region)
   - Create outputs for versioning status and lifecycle rule IDs
   - Configure helper outputs with S3 paths and AWS CLI commands
   - Define a console URL output for easy bucket access

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the resources to be created:
   - S3 bucket with versioning and encryption
   - Lifecycle configuration with multiple rules
   - Bucket policy for HTTPS enforcement
   - Folder structures and test objects
   - CloudWatch alarm for monitoring

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, Terraform will display outputs including:
   - Bucket name and ARN
   - S3 paths for different folders
   - AWS CLI commands for testing
   - Console URL for web access

### Step 7: Test and Verify Your Configuration

1. View the bucket in the AWS Console:
   ```bash
   # Use the console URL from Terraform output
   echo $(terraform output -raw s3_console_url)
   ```

2. List the objects in your bucket:
   ```bash
   # Use the AWS CLI list command from Terraform output
   $(terraform output -raw aws_cli_list_objects)
   ```

3. Check object versions to verify versioning:
   ```bash
   # Use the versions command from Terraform output
   $(terraform output -raw aws_cli_list_versions)
   ```

4. Upload additional test files:
   ```bash
   # Create a test file
   echo "Test content $(date)" > testfile.txt
   
   # Upload using the command from Terraform output
   aws s3 cp testfile.txt $(terraform output -raw standard_folder_path)
   
   # Modify and upload again to create a version
   echo "Updated content $(date)" > testfile.txt
   aws s3 cp testfile.txt $(terraform output -raw standard_folder_path)
   ```

5. Verify lifecycle rules in the console:
   - Navigate to the S3 console
   - Select your bucket
   - Go to the "Management" tab
   - Check the lifecycle configuration

---

## 🔍 Understanding S3 Lifecycle Management

### S3 Storage Lifecycle Diagram

```
                                     Object Creation
                                           |
                                           v
+-----------------------------------------------------------------------------------+
|                                Standard Storage                                    |
|                                                                                   |
|  Immediate access, high throughput, low latency, most expensive storage class     |
|                                                                                   |
+------------------------------------------+--------------------------------------+--+
                                           |
                                           | After 30 days (days_to_standard_ia)
                                           v
+-----------------------------------------------------------------------------------+
|                              Standard-IA Storage                                   |
|                                                                                   |
|  Less frequent access, lower cost, small retrieval fee, min 30 days retention     |
|                                                                                   |
+------------------------------------------+--------------------------------------+--+
                                           |
                                           | After 60 days (days_to_glacier)
                                           v
+-----------------------------------------------------------------------------------+
|                                Glacier Storage                                     |
|                                                                                   |
|  Archival storage, very low cost, retrieval delay (minutes to hours)              |
|                                                                                   |
+------------------------------------------+--------------------------------------+--+
                                           |
                                           | After 365 days (days_to_expiration)
                                           v
                                    Object Deleted
                                 
+-----------------------------------------------------------------------------------+
|                                 Version Timeline                                   |
|                                                                                   |
|  Current Version  <---  Previous Version  <---  Previous Version  <---  etc.      |
|       Active           To Glacier after      Deleted after                        |
|                        30 days noncurrent    90 days noncurrent                   |
|                                                                                   |
+-----------------------------------------------------------------------------------+
```

### Key Lifecycle Rule Categories

1. **Standard Tier Transitions**:
   ```hcl
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
     # Additional transitions...
   }
   ```

2. **Version Management**:
   ```hcl
   rule {
     id     = "version-management"
     status = "Enabled"
     filter {
       prefix = ""
     }
     noncurrent_version_transition {
       noncurrent_days = 30
       storage_class   = "GLACIER"
     }
     # Expiration configuration...
   }
   ```

3. **Multipart Upload Management**:
   ```hcl
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
   ```

4. **Log Files Management**:
   ```hcl
   rule {
     id     = "logs-management"
     status = "Enabled"
     filter {
       prefix = var.logs_prefix
     }
     # Transitions and expiration for logs...
   }
   ```

---

## 💡 Key Learning Points

1. **S3 Storage Optimization Principles**:
   - Matching storage class to access patterns to reduce costs
   - Using lifecycle policies for automated management
   - Implementing versioning for data protection
   - Securing buckets with policies and encryption

2. **Lifecycle Management Concepts**:
   - Storage class transitions based on age
   - Object expiration to control storage growth
   - Version management to balance history and cost
   - Prefix-based rules for different data categories

3. **Terraform Techniques**:
   - Using resources for S3 bucket configuration
   - Working with JSON policies in Terraform
   - Creating conditional and rule-based resources
   - Managing sensitive settings with variables

4. **AWS S3 Best Practices**:
   - Enforcing HTTPS for secure data transfer
   - Using server-side encryption for data at rest
   - Blocking public access by default
   - Monitoring storage with CloudWatch metrics

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Implement Intelligent-Tiering**:
   Set up an additional rule using the S3 Intelligent-Tiering storage class
   ```hcl
   rule {
     id     = "intelligent-tiering-rule"
     status = "Enabled"
     filter {
       prefix = "data/"
     }
     transition {
       days          = 0
       storage_class = "INTELLIGENT_TIERING"
     }
   }
   ```

2. **Add Cross-Region Replication**:
   Configure replication to another region for disaster recovery
   ```hcl
   resource "aws_s3_bucket_replication_configuration" "replication" {
     bucket = aws_s3_bucket.lifecycle_demo.id
     role   = aws_iam_role.replication_role.arn

     rule {
       id     = "replicate-all"
       status = "Enabled"
       
       destination {
         bucket        = aws_s3_bucket.destination.arn
         storage_class = "STANDARD"
       }
     }
   }
   ```

3. **Implement Object-Level Logging**:
   Set up CloudTrail to track object-level operations
   ```hcl
   resource "aws_cloudtrail" "s3_trail" {
     name                          = "${var.name_prefix}-s3-trail"
     s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
     include_global_service_events = true
     
     event_selector {
       read_write_type                  = "All"
       include_management_events        = true
       
       data_resource {
         type   = "AWS::S3::Object"
         values = ["${aws_s3_bucket.lifecycle_demo.arn}/"]
       }
     }
   }
   ```

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. First, confirm that you want to delete all objects in the bucket:
   ```bash
   # List all objects in the bucket
   aws s3 ls s3://$(terraform output -raw bucket_name) --recursive
   
   # If you need to save any objects, download them now
   aws s3 cp s3://$(terraform output -raw bucket_name)/standard/important-file.txt ./
   ```

2. When ready, destroy the infrastructure:
   ```bash
   terraform destroy
   ```

3. Type `yes` when prompted to confirm.

4. Verify that the bucket has been deleted:
   ```bash
   # Check if the bucket still exists
   aws s3api head-bucket --bucket $(terraform output -raw bucket_name) 2>&1 || echo "Bucket has been deleted"
   ```

5. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars
   
   # Remove any test files you created
   rm -f testfile.txt
   ```

> ⚠️ **Important Note**: S3 buckets with versioning enabled contain multiple versions of objects. When you destroy the bucket, all versions and delete markers are also removed.

---

## 🚫 Common Errors and Troubleshooting

1. **Bucket Name Already Exists**:
   ```
   Error: Error creating S3 bucket: BucketAlreadyExists: The requested bucket name is not available.
   ```
   **Solution**: Choose a different globally unique bucket name in your terraform.tfvars file.

2. **Policy Size Limitations**:
   ```
   Error: Error putting S3 policy: EntityTooLarge: Your policy contains too many resources
   ```
   **Solution**: Simplify your bucket policy by using wildcards or splitting it into multiple policies.

3. **Versioning Transition Issues**:
   ```
   Error: Error putting S3 lifecycle: InvalidRequest: Lifecycle is not supported for versioning suspended bucket
   ```
   **Solution**: Ensure versioning is enabled before applying lifecycle rules with version transitions.

4. **Permission Denied**:
   ```
   Error: Access Denied when accessing S3 bucket
   ```
   **Solution**: Check your AWS credentials and ensure you have the necessary permissions for S3 operations.

5. **Bucket Not Empty on Destroy**:
   ```
   Error: Error deleting S3 bucket: BucketNotEmpty: The bucket you tried to delete is not empty
   ```
   **Solution**: This shouldn't happen when using Terraform, but if it does, you may need to manually empty the bucket first.

---

## 📚 Additional Resources

- [S3 Lifecycle Management Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)
- [S3 Versioning Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
- [S3 Storage Classes Reference](https://aws.amazon.com/s3/storage-classes/)
- [Terraform AWS Provider - S3 Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [S3 Pricing Calculator](https://calculator.aws/#/createCalculator/S3)
- [AWS S3 Best Practices](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html)

---

## 🚀 Next Lab

Proceed to [LAB09-Route53](../LAB09-Route53/) to learn how to set up a custom domain name for your content using Amazon Route 53 and DNS management.

---

Happy Terraforming!