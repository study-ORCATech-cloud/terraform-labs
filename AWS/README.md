# AWS Terraform Labs

Welcome to the AWS section of our Terraform Labs! This collection contains hands-on labs designed to teach you how to provision and manage Amazon Web Services resources using Terraform, the popular Infrastructure as Code (IaC) tool.

## 🎯 Learning Objectives

By completing these labs, you will:
- Master Terraform for AWS resource provisioning and management
- Learn AWS-specific concepts and best practices
- Understand how to create reproducible, version-controlled infrastructure
- Develop skills to automate cloud deployments in a real-world context

## 📋 Lab Overview

| Lab | Name | Description | Key Concepts |
|-----|------|-------------|-------------|
| LAB01 | [EC2 Instance](LAB01-EC2-Instance/) | Deploy virtual machines in AWS | EC2, Security Groups, Key Pairs |
| LAB02 | [S3 Bucket](LAB02-S3-Bucket/) | Create object storage and static websites | S3, Policies, Static Website Hosting |
| LAB03 | [IAM](LAB03-IAM/) | Configure identity and access management | IAM Users, Roles, Policies |
| LAB04 | [VPC](LAB04-VPC/) | Set up virtual private clouds | VPC, Subnets, Route Tables, Internet Gateways |
| LAB05 | [ELB & ASG](LAB05-ELB-ASG/) | Build scalable application infrastructure | Load Balancers, Auto Scaling Groups |
| LAB06 | [CloudWatch](LAB06-CLOUDWATCH/) | Implement monitoring and alerts | Metrics, Alarms, Logs, Dashboards |
| LAB07 | [RDS](LAB07-RDS/) | Deploy managed relational databases | RDS, Parameter Groups, Snapshots |
| LAB08 | [S3 Lifecycle](LAB08-S3-Lifecycle/) | Automate object lifecycle management | Lifecycle Rules, Storage Classes, Versioning |
| LAB09 | [Route 53](LAB09-Route53/) | Configure DNS management | DNS Zones, Record Sets, Health Checks |
| LAB10 | [Lambda](LAB10-Lambda/) | Deploy serverless functions | Lambda, API Gateway, Event Sources |

## 🚀 Getting Started

### Prerequisites

To complete these labs, you'll need:
- An AWS account (free tier works for most labs)
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+) installed
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- A code editor (VS Code recommended)

### Setup Instructions

1. **Clone this repository**:
   ```bash
   git clone https://github.com/ORCATech-study/terraform-labs.git
   cd terraform-labs/AWS
   ```

2. **Configure AWS credentials**:
   ```bash
   aws configure
   ```
   You'll need to provide:
   - AWS Access Key ID
   - AWS Secret Access Key
   - Default region (e.g., eu-west-1)
   - Output format (json recommended)

3. **Choose a lab**:
   ```bash
   cd LAB01-EC2-Instance
   ```

4. **Initialize Terraform**:
   ```bash
   terraform init
   ```

5. **Follow lab-specific instructions** in each lab's README.md

## 📚 Lab Structure

Each lab follows a consistent structure:

- **README.md**: Contains lab instructions, objectives, and explanations
- **main.tf**: Primary Terraform configuration with resources to create
- **variables.tf**: Input variables with descriptions and default values
- **outputs.tf**: Output values to display after deployment
- **terraform.tfvars**: Variable values specific to the lab
- **solutions.md**: Detailed explanations and complete solutions (for instructors)

## ⚙️ Lab Workflow

1. **Read the README.md** file to understand the lab objectives
2. **Review the TODO sections** in the Terraform files
3. **Complete the lab tasks** by filling in the required configurations
4. **Apply your configuration** using Terraform commands
5. **Verify resources** were created correctly in the AWS Management Console
6. **Clean up resources** when finished using `terraform destroy`

## 🛡️ AWS-Specific Best Practices

1. **Account Structure**:
   - Consider using AWS Organizations for multi-account setup
   - Apply Service Control Policies (SCPs) for governance
   - Use separate accounts for different environments (dev, test, prod)

2. **Resource Naming**:
   - Use consistent naming conventions with prefixes/suffixes
   - Include environment and purpose in resource names
   - Be mindful of AWS service-specific naming constraints

3. **Security**:
   - Follow the principle of least privilege for IAM policies
   - Use IAM roles instead of hardcoded credentials
   - Enable MFA for IAM users with console access
   - Utilize Security Groups as precise as possible

4. **Networking**:
   - Design VPCs with proper CIDR blocks for future growth
   - Use private subnets for backend resources
   - Implement security in layers (NACLs and Security Groups)
   - Consider VPC endpoints for AWS services

5. **State Management**:
   - Store Terraform state in an S3 bucket with versioning
   - Enable state locking with DynamoDB
   - Use workspaces or separate state files for different environments

## 🏆 Learning Path

We recommend completing the labs in numerical order, as concepts build upon previous labs:

1. Start with compute and storage fundamentals (Labs 1-2)
2. Learn about identity and networking (Labs 3-4)
3. Implement scalable architectures (Lab 5)
4. Set up monitoring and databases (Labs 6-7)
5. Explore advanced storage features (Lab 8)
6. Configure DNS and serverless computing (Labs 9-10)

## 🔍 Troubleshooting Tips

1. **Authentication Issues**:
   ```bash
   # Verify AWS credentials
   aws sts get-caller-identity
   
   # Check configured profiles
   aws configure list
   
   # List available profiles
   aws configure list-profiles
   ```

2. **Resource Limitations**:
   - Check service quotas in the AWS Console
   - Request service quota increases if needed
   - Be aware of regional service availability

3. **State Issues**:
   ```bash
   # Refresh the state file
   terraform refresh
   
   # View current state
   terraform state list
   
   # Import existing resources into state
   terraform import [address] [id]
   ```

4. **Common AWS Errors**:
   - "AccessDenied": Check IAM permissions for your user/role
   - "LimitExceeded": Verify service quotas and limits
   - "ResourceAlreadyExists": Ensure unique resource names within their scope
   - "VPCIdNotSpecified": Many resources require explicit VPC assignment

## 🧹 Cleanup

After completing each lab, remember to destroy the resources to avoid unexpected AWS charges:

```bash
terraform destroy
```

Always verify in the AWS Console that all resources have been properly terminated.

## 📖 Additional Resources

- [AWS Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [AWS Hands-On Tutorials](https://aws.amazon.com/getting-started/hands-on/) 