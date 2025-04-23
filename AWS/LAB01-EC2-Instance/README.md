# LAB01: Provisioning an EC2 Instance with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to provision a basic EC2 instance running a web server on AWS. You'll learn how Infrastructure as Code (IaC) can automate cloud provisioning tasks that would otherwise be performed manually in the AWS Console.

---

## 🎯 Learning Objectives

- Initialize a Terraform working directory
- Configure the AWS provider
- Define and use input variables
- Deploy an EC2 instance with a security group
- Output key resource information
- Clean up resources to avoid unexpected charges

---

## 🧰 Prerequisites

- AWS account with administrator access
- AWS CLI installed and configured with access credentials
- Terraform v1.3+ installed
- SSH key pair generated on your local machine

---

## 📁 Files Structure

```
AWS/LAB01-EC2-Instance/
├── main.tf                  # Main configuration file with resource definitions
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

2. Ensure you have an SSH key pair:
   ```bash
   # Check if you already have a key
   ls ~/.ssh/id_rsa.pub
   
   # If not, generate a new key pair
   ssh-keygen -t rsa -b 2048
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB01-EC2-Instance
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure Variables (Optional)

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit the `terraform.tfvars` file to customize your deployment:
   ```bash
   # Example modifications
   aws_region    = "eu-west-1"  # Change region
   instance_type = "t3.micro"   # Change instance type
   ```

### Step 4: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. Verify the resources to be created:
   - Security group rules
   - EC2 instance configuration

### Step 5: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to approve the actions

3. Wait for the infrastructure to be provisioned (typically 1-2 minutes)

### Step 6: Explore Your Deployment

1. After successful application, Terraform will output:
   - Instance ID
   - Public IP address
   - SSH connection command

2. Access the web server by opening the public IP in a browser:
   ```
   http://<instance_public_ip>
   ```

3. Connect to your instance via SSH:
   ```bash
   # Using the output SSH command
   ssh -i ~/.ssh/id_rsa ec2-user@<instance_public_dns>
   ```

---

## 🔍 Understanding the Code

### Provider Configuration
```hcl
provider "aws" {
  region = var.aws_region
}
```
Establishes the connection to AWS in the specified region.

### Security
- **Security Group**: Acts as a virtual firewall for the instance
  - Allows inbound SSH (port 22) for remote management
  - Allows inbound HTTP (port 80) for web server access
  - Allows all outbound traffic

### Computing
- **Key Pair**: Registers your public SSH key for secure access
- **EC2 Instance**: Provisions a virtual machine with:
  - Amazon Linux 2 AMI
  - t2.micro instance type (free tier eligible)
  - User data script to install and configure Apache

---

## 💡 Learning Points

- **Infrastructure as Code**: Managing infrastructure through code offers repeatability and version control
- **Resource Dependencies**: Terraform automatically handles resource creation order
- **User Data**: Bootstrapping instances at launch saves manual configuration
- **Output Values**: Retrieving deployment information streamlines usage
- **Variable Defaults**: Setting sensible defaults while allowing customization

---

## 🛠️ Troubleshooting

### Common Issues:

1. **AWS Credentials Error**: 
   ```
   Error: No valid credential sources found
   ```
   **Solution**: Configure AWS CLI or set environment variables with your credentials.

2. **SSH Key Not Found**:
   ```
   Error: failed to read public key: open ~/.ssh/id_rsa.pub: no such file or directory
   ```
   **Solution**: Generate a key pair or specify the correct path in variables.

3. **Resource Limits**:
   ```
   Error: Error launching source instance: VcpuLimitExceeded
   ```
   **Solution**: Request a service limit increase or use a different instance type.

---

## ✅ Challenge Exercises

Ready for more? Try these enhancements:

1. **Add Tags**: Implement additional tags like Owner, Project, or Cost Center
2. **Modify User Data**: Update the script to install and configure a different web server (like Nginx)
3. **Create Custom VPC**: Extend the configuration to create a custom VPC instead of using the default VPC

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. Destroy all resources:
   ```bash
   terraform destroy
   ```

2. Type `yes` when prompted

3. Verify in the AWS Console that all resources have been deleted:
   - EC2 instance terminated
   - Security groups deleted

4. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate*
   ```

> ⚠️ **Important**: Always remember to destroy your resources when you're done to avoid unexpected charges on your AWS account.

---

## 📚 Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)
- [AWS Security Groups Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

---

## 🚀 Next Lab

Proceed to [LAB02-S3-Bucket](../LAB02-S3-Bucket/) to learn how to provision and configure Amazon S3 buckets using Terraform.

---

Happy Terraforming!