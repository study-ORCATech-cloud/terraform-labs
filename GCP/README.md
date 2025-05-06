# Google Cloud Platform Terraform Labs

Welcome to the GCP section of our Terraform Labs! This collection contains hands-on labs designed to teach you how to provision and manage Google Cloud resources using Terraform, the popular Infrastructure as Code (IaC) tool.

## 🎯 Learning Objectives

By completing these labs, you will:
- Master Terraform for Google Cloud resource provisioning and management
- Learn GCP-specific concepts and best practices
- Understand how to create reproducible, version-controlled infrastructure
- Develop skills to automate cloud deployments in a real-world context

## 📋 Lab Overview

| Lab | Name | Description | Key Concepts |
|-----|------|-------------|-------------|
| LAB01 | [Compute Engine](LAB01-Compute-Engine/) | Deploy GCP virtual machines | Compute Engine, Persistent Disks, Metadata |
| LAB02 | [Cloud Storage](LAB02-Cloud-Storage/) | Create buckets and manage access | Storage Buckets, IAM, Object Lifecycle |
| LAB03 | [IAM Roles](LAB03-IAM-Roles/) | Configure identity and access management | Service Accounts, IAM Roles, Custom Roles |
| LAB04 | [VPC & Firewall](LAB04-VPC-Firewall/) | Set up virtual networks with security | VPC Networks, Subnets, Firewall Rules |
| LAB05 | [Load Balancer & Instance Group](LAB05-LoadBalancer-InstanceGroup/) | Create scalable infrastructure | HTTP Load Balancer, Managed Instance Groups |
| LAB06 | [Cloud Monitoring](LAB06-CloudMonitoring/) | Implement monitoring and alerts | Monitoring, Alerts, Dashboards |
| LAB07 | [Cloud SQL](LAB07-CloudSQL/) | Deploy managed database instances | Cloud SQL, Postgres/MySQL, High Availability |
| LAB08 | [Storage Lifecycle](LAB08-CloudStorage-Lifecycle/) | Automate object storage management | Lifecycle Policies, Object Versioning |
| LAB09 | [Cloud DNS & Domain](LAB09-CloudDNS-Domain/) | Configure DNS zones and records | DNS Zones, DNS Records, Domain Registration |
| LAB10 | [Cloud Functions HTTP](LAB10-CloudFunctions-HTTP/) | Deploy serverless functions | Cloud Functions, HTTP Triggers, IAM |

## 🚀 Getting Started

### Prerequisites

To complete these labs, you'll need:
- A Google Cloud account (free tier works for most labs)
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+) installed
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed
- A code editor (VS Code recommended)

### Setup Instructions

1. **Clone this repository**:
   ```bash
   git clone https://github.com/ORCATech-study/terraform-labs.git
   cd terraform-labs/GCP
   ```

2. **Log in to Google Cloud**:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```

3. **Set your GCP project**:
   ```bash
   gcloud config set project YOUR_PROJECT_ID
   ```

4. **Choose a lab**:
   ```bash
   cd LAB01-Compute-Engine
   ```

5. **Initialize Terraform**:
   ```bash
   terraform init
   ```

6. **Follow lab-specific instructions** in each lab's README.md

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
5. **Verify resources** were created correctly in the Google Cloud Console
6. **Clean up resources** when finished using `terraform destroy`

## 🛡️ GCP-Specific Best Practices

1. **Project Structure**:
   - Organize resources by project
   - Use folders for organizational hierarchy when needed
   - Leverage projects for isolation and billing boundaries

2. **Resource Naming**:
   - Use consistent naming conventions (e.g., `<environment>-<resource-type>-<purpose>`)
   - Keep names lowercase with hyphens for better readability
   - Include project/environment identifiers in global resource names

3. **IAM and Security**:
   - Follow the principle of least privilege
   - Use service accounts with minimal necessary permissions
   - Leverage custom roles when standard roles are too broad

4. **Networking**:
   - Design VPCs with proper CIDR ranges for future expansion
   - Use shared VPCs for multi-project environments
   - Implement defense-in-depth with multiple security layers

5. **State Management**:
   - Store Terraform state in a GCS bucket with versioning enabled
   - Use state locking to prevent concurrent modifications
   - Consider separate state files for different environments

## 🏆 Learning Path

We recommend completing the labs in numerical order, as concepts build upon previous labs:

1. Start with basic compute and storage (Labs 1-2)
2. Learn about security and networking (Labs 3-4)
3. Implement scalable architectures (Lab 5)
4. Set up monitoring and databases (Labs 6-7)
5. Explore advanced storage features (Lab 8)
6. Configure DNS and serverless computing (Labs 9-10)

## 🔍 Troubleshooting Tips

1. **Authentication Issues**:
   ```bash
   # Verify authentication setup
   gcloud auth list

   # Check active project
   gcloud config get-value project

   # Refresh application default credentials
   gcloud auth application-default login
   ```

2. **Quota and Limits**:
   - Check quota usage in Google Cloud Console
   - Request quota increases for specific resources if needed
   - Be aware of regional resource limitations

3. **State Issues**:
   ```bash
   # Refresh the state file
   terraform refresh
   
   # View current state
   terraform state list
   
   # Import existing resources into state
   terraform import [address] [id]
   ```

4. **Common GCP Errors**:
   - "Permission denied": Check IAM roles and service account permissions
   - "Resource already exists": GCP resources must have unique names within their scope
   - "Quota exceeded": Verify your project has sufficient quota for the requested resources

## 🧹 Cleanup

After completing each lab, remember to destroy the resources to avoid unexpected GCP charges:

```bash
terraform destroy
```

## 📖 Additional Resources

- [Google Cloud Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Google Cloud Architecture Center](https://cloud.google.com/architecture)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Google Cloud Skills Boost](https://www.cloudskillsboost.google/)
- [Google Cloud Community Tutorials](https://cloud.google.com/community/tutorials) 