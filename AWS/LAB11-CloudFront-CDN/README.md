# LAB11: AWS CloudFront CDN with S3 Origin

## 📝 Lab Overview

In this lab, you'll use Terraform to create a **CloudFront Distribution** with an S3 bucket as origin. You'll configure caching behaviors, custom error responses, geographic restrictions, and implement HTTPS using AWS Certificate Manager (ACM).

---

## 🎯 Learning Objectives

- Deploy a CloudFront distribution with an S3 origin using Terraform
- Configure caching behaviors and TTLs for different content types
- Set up custom error responses and error pages
- Implement HTTPS with AWS Certificate Manager
- Apply geo-restrictions to content delivery
- Configure Origin Access Identity (OAI) for secure S3 access
- Add CloudFront Functions for request/response manipulation

---

## 📋 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.0+ installed
- AWS CLI configured with appropriate credentials
- Basic understanding of CDNs and content delivery concepts
- Completion of LAB02 (S3 Bucket) is recommended

---

## 📁 Lab Files

- `main.tf`: CloudFront distribution and associated resources
- `variables.tf`: Input variables for customization
- `outputs.tf`: CloudFront domain name and distribution ID
- `terraform.tfvars`: Configuration values
- `s3-policy.json`: Sample bucket policy for CloudFront OAI

---

## 🔨 Lab Tasks

1. **Create an S3 bucket for static content**:
   - Configure the bucket for website hosting
   - Upload sample content (HTML, CSS, JS, images)

2. **Create Origin Access Identity**:
   - Set up OAI for secure CloudFront-to-S3 access
   - Configure S3 bucket policy to allow access only from CloudFront

3. **Deploy CloudFront Distribution**:
   - Configure origins, behaviors, and cache settings
   - Set up HTTPS with ACM certificate
   - Implement caching strategies for different content types

4. **Configure Custom Error Responses**:
   - Create custom error pages in S3
   - Configure CloudFront to serve these pages for different error codes

5. **Implement Geographic Restrictions**:
   - Set up geo-restriction to block or allow specific countries
   - Test access from different regions

6. **Add CloudFront Functions**:
   - Create a basic request manipulation function
   - Deploy and associate it with the distribution

7. **Implement Cache Invalidation**:
   - Create Terraform resources to manage cache invalidation
   - Test updating content and invalidating the cache

---

## 💡 Expected Outcomes

After completing this lab, you'll have:
- A fully functional CloudFront distribution serving content from S3
- Secure access pattern using Origin Access Identity
- Optimized caching behaviors for different content types
- Custom error handling and geo-restrictions
- HTTPS enabled with an ACM certificate

---

## 📚 Advanced Challenges

- Set up custom domain with Route 53 and ACM
- Implement A/B testing with Lambda@Edge
- Configure multiple origins (S3 + custom origin)
- Add WAF integration for security
- Implement real-time logs to CloudWatch

---

## 🧹 Cleanup

To avoid unexpected charges, make sure to destroy all resources when you're done:

```bash
terraform destroy
```

Key resources to verify deletion:
- CloudFront distribution
- S3 buckets
- ACM certificates
- IAM roles and policies
- CloudFront Functions

---

## 📖 Additional Resources

- [CloudFront Terraform Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)
- [AWS CloudFront Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)
- [CloudFront Functions Documentation](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/cloudfront-functions.html)
- [Best Practices for CloudFront](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-cache-and-origin-request-policies/) 