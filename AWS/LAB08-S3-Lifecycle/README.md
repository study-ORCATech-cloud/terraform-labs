# LAB08: Advanced S3 Bucket Lifecycle Management and Versioning with Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll implement **Amazon S3 bucket lifecycle policies** and **object versioning** using **Terraform**. You'll create a bucket with multiple storage tiers, automated transitions between storage classes, expiration rules, and versioning to protect against accidental deletions. These features help optimize storage costs while maintaining data durability and accessibility for different access patterns.

---

## 🎯 Objectives

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

## 📁 File Structure

```bash
AWS/LAB08-S3-Lifecycle/
├── main.tf          # S3 bucket, versioning, and lifecycle configurations
├── variables.tf     # Variable definitions for customization
├── outputs.tf       # Output values for bucket info and helper commands
├── terraform.tfvars # Variable values configuration
└── README.md        # This documentation file
```

---

## 🚀 Steps to Complete the Lab

### 1. Prepare Your Environment

1. **Review and customize the terraform.tfvars file**
   - Set your preferred region (default: eu-west-1)
   - Change the bucket name to something globally unique
   - Configure lifecycle transition days based on your requirements
   - Adjust expiration periods if needed

### 2. Deploy Your S3 Environment

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review the deployment plan**
   ```bash
   terraform plan
   ```

3. **Apply the configuration**
   ```bash
   terraform apply
   ```

4. **Record the outputs**
   - Bucket name and ARN
   - Folder paths
   - Useful AWS CLI commands

### 3. Explore and Test Your S3 Bucket

#### A. View Bucket Configuration in AWS Console

1. **Navigate to the S3 console**
   - Use the console URL provided in the outputs
   - Alternatively, go to https://s3.console.aws.amazon.com/

2. **Explore bucket properties**
   - Verify versioning is enabled
   - Check the lifecycle rules
   - Review the bucket policy

#### B. Test Object Uploads and Versioning

1. **Upload files using the AWS CLI**
   ```bash
   # Create a sample file
   echo "Original content" > test-file.txt
   
   # Upload to the standard folder
   aws s3 cp test-file.txt s3://YOUR-BUCKET-NAME/standard/
   
   # Modify and upload again to create a new version
   echo "Updated content" > test-file.txt
   aws s3 cp test-file.txt s3://YOUR-BUCKET-NAME/standard/
   ```

2. **List object versions**
   ```bash
   aws s3api list-object-versions --bucket YOUR-BUCKET-NAME --prefix standard/test-file.txt
   ```

3. **Restore a previous version** (if needed)
   ```bash
   aws s3api copy-object \
     --copy-source "YOUR-BUCKET-NAME/standard/test-file.txt?versionId=VERSION-ID" \
     --bucket YOUR-BUCKET-NAME \
     --key standard/test-file.txt
   ```

#### C. Simulate Lifecycle Transitions

*Note: Actual transitions will occur based on the configured time periods. This section shows how to verify the configuration and simulate the behavior.*

1. **Check lifecycle rules in the console**
   - Navigate to the S3 console
   - Select your bucket
   - Go to the "Management" tab
   - Review the lifecycle rules

2. **Use AWS CLI to check object storage class**
   ```bash
   aws s3api head-object --bucket YOUR-BUCKET-NAME --key standard/test-file.txt
   ```

---

## 🔍 Key Components and Concepts

### Storage Classes and Lifecycle Management

| Storage Class | Use Case | Retrieval Time | Minimum Storage Duration |
|---------------|----------|----------------|-------------------------|
| STANDARD      | Frequently accessed data | Immediate | None |
| STANDARD_IA   | Long-lived, infrequently accessed data | Milliseconds | 30 days |
| GLACIER       | Long-term archive, rare access | Minutes to hours | 90 days |
| DEEP_ARCHIVE  | Long-term retention, very rare access | Hours | 180 days |

### Versioning Benefits

- **Protection against accidental deletions**: Previous versions are preserved
- **Recovery from unintended overwrites**: Restore previous versions of objects
- **Audit trail**: Track changes to objects over time
- **Rollback capability**: Return to any previous version of an object

### Lifecycle Rules in This Lab

1. **Standard-IA Transition**: Objects in the standard folder move to Standard-IA after 30 days
2. **Glacier Transition**: Objects in the standard folder move to Glacier after 60 days
3. **Object Expiration**: Objects are deleted after 365 days
4. **Version Management**: Non-current versions transition to Glacier after 30 days and expire after 90 days
5. **Incomplete Multipart Upload Management**: Incomplete multipart uploads are aborted after 7 days
6. **Log Management**: Log files transition through storage classes and expire after 180 days

---

## 📊 Cost Implications and Best Practices

- **Right-sizing storage classes**: Match access patterns to appropriate storage classes
- **Transition costs**: Be aware that transitions between storage classes incur costs
- **Minimum storage durations**: Objects moved to lower-cost tiers have minimum storage duration charges
- **Retrieval costs**: Glacier and Deep Archive have retrieval fees
- **Versioning storage costs**: Each version consumes storage and incurs charges
- **Lifecycle as a cost management tool**: Automate movement of data to balance access needs and costs

---

## 🧼 Cleanup

When you've completed the lab, destroy all resources to avoid incurring additional costs:

```bash
terraform destroy
```

**Note**: This will delete the S3 bucket and all objects stored in it. Make sure to download any important files before running this command.

---

## 💡 Advanced Extensions

Take your learning further with these advanced challenges:

1. **Implement Intelligent Tiering**
   - Modify the configuration to use the S3 Intelligent-Tiering storage class

2. **Add S3 Event Notifications**
   - Configure notifications for object creations, deletions, or transitions

3. **Implement Object Tagging**
   - Use tags on objects to control which lifecycle rules apply

4. **Set Up S3 Inventory**
   - Configure S3 Inventory to track object versions and storage classes

5. **Create Custom Storage Class Analysis**
   - Use S3 Analytics to understand access patterns and optimize storage classes

---

## 📚 References

- [S3 Lifecycle Management Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html)
- [S3 Versioning Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
- [S3 Storage Classes](https://aws.amazon.com/s3/storage-classes/)
- [Terraform AWS Provider - S3 Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [S3 Pricing](https://aws.amazon.com/s3/pricing/)

---

## ✅ Key Takeaways

After completing this lab, you'll understand how to:

- Implement cost-effective storage strategies with S3 lifecycle rules
- Protect data using S3 versioning for recovery and audit capabilities
- Use infrastructure as code to manage complex S3 configurations
- Balance storage costs with data accessibility requirements
- Implement security best practices for S3 buckets