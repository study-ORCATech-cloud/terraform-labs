# Azure Terraform Labs

Welcome to the Azure section of our Terraform Labs! This collection contains hands-on labs designed to teach you how to provision and manage Azure cloud resources using Terraform, the popular Infrastructure as Code (IaC) tool.

## 🎯 Learning Objectives

By completing these labs, you will:
- Master Terraform for Azure resource provisioning and management
- Learn Azure-specific concepts and best practices
- Understand how to create reproducible, version-controlled infrastructure
- Develop skills to automate Azure deployments in a real-world context

## 📋 Lab Overview

| Lab | Name | Description | Key Concepts |
|-----|------|-------------|-------------|
| LAB01 | [Virtual Machine](LAB01-Virtual-Machine/) | Deploy Azure VMs with networking and storage | Virtual Machines, NSGs, Public IPs |
| LAB02 | [Storage Account](LAB02-Storage-Account/) | Create and configure blob storage | Storage Accounts, Containers, Access Control |
| LAB03 | [Azure AD](LAB03-AzureAD/) | Set up identity and access management | Azure AD, RBAC, Service Principals |
| LAB04 | [VNET](LAB04-VNET/) | Configure virtual networks and subnets | VNets, Subnets, Network Security |
| LAB05 | [LoadBalancer & Scale Set](LAB05-LoadBalancer-ScaleSet/) | Implement scalable application infrastructure | Load Balancers, VM Scale Sets, Auto-scaling |
| LAB06 | [Monitor & Log Analytics](LAB06-Monitor-LogAnalytics/) | Set up monitoring and logging | Metrics, Alerts, Diagnostic Settings |
| LAB07 | [SQL Database](LAB07-SQL-Database/) | Deploy managed relational databases | Azure SQL, Firewall Rules, Security |
| LAB08 | [Lifecycle Policies](LAB08-Lifecycle-Policies/) | Automate data lifecycle management | Blob Storage Lifecycle, Tiering |
| LAB09 | [Azure DNS & Domain](LAB09-AzureDNS-Domain/) | Configure DNS for custom domains | DNS Zones, A/CNAME Records, MX Records |
| LAB10 | [Functions & HTTP Trigger](LAB10-Functions-HTTPTrigger/) | Deploy serverless functions | Azure Functions, Triggers, App Service Plan |

## 🚀 Getting Started

### Prerequisites

To complete these labs, you'll need:
- An Azure account (free tier works for most labs)
- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+) installed
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- A code editor (VS Code recommended)

### Setup Instructions

1. **Clone this repository**:
   ```bash
   git clone https://github.com/ORCATech-study/terraform-labs.git
   cd terraform-labs/Azure
   ```

2. **Log in to Azure**:
   ```bash
   az login
   ```

3. **Choose a lab**:
   ```bash
   cd LAB01-Virtual-Machine
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
5. **Verify resources** were created correctly in the Azure portal
6. **Clean up resources** when finished using `terraform destroy`

## 🛡️ Azure-Specific Best Practices

1. **Resource Naming**:
   - Use consistent naming conventions (e.g., `<project>-<environment>-<resource-type>-<instance>`)
   - Keep in mind Azure's resource name constraints (character limits, allowed characters)

2. **Resource Groups**:
   - Group related resources by lifecycle and function
   - Use resource groups for access control and cost tracking

3. **Tagging Strategy**:
   - Tag all resources with owner, environment, project, cost center
   - Use tags for resource organization and cost allocation

4. **State Management**:
   - Use remote state with Azure Storage Account for team environments
   - Enable state locking to prevent concurrent modifications

5. **Security**:
   - Use Azure Key Vault for sensitive values
   - Implement least privilege access with Azure RBAC
   - Avoid storing credentials in Terraform files

## 🏆 Learning Path

We recommend completing the labs in numerical order, as concepts build upon previous labs:

1. Start with basic resource creation (Labs 1-2)
2. Move to networking and identity (Labs 3-4)
3. Learn about high availability and scaling (Lab 5)
4. Master monitoring and databases (Labs 6-7)
5. Explore advanced concepts like lifecycle management and DNS (Labs 8-9)
6. Finish with serverless computing (Lab 10)

## 🔍 Troubleshooting Tips

1. **Authentication Issues**:
   ```bash
   # Check if you're logged in and using the right subscription
   az account show
   
   # List available subscriptions
   az account list --output table
   
   # Set a specific subscription
   az account set --subscription "Subscription Name"
   ```

2. **Resource Provision Failures**:
   - Check Azure resource name uniqueness
   - Verify resource quota limits in your subscription
   - Look for dependent resources that might be missing

3. **State Issues**:
   ```bash
   # Refresh the state file
   terraform refresh
   
   # View current state
   terraform state list
   ```

4. **Common Azure Errors**:
   - "PrincipalNotFound": Ensure your service principal has proper permissions
   - "StorageAccountAlreadyExists": Storage account names must be globally unique
   - "QuotaExceeded": Check your subscription limits and request increases if needed

## 🧹 Cleanup

After completing each lab, remember to destroy the resources to avoid unexpected Azure charges:

```bash
terraform destroy
```

## 📖 Additional Resources

- [Azure Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Microsoft Learn - Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Azure Architecture Center](https://learn.microsoft.com/en-us/azure/architecture/)
- [Azure Cloud Adoption Framework](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/) 