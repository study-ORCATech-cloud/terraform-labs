# Terraform Workspace Setup Guide

This guide will help you set up your local development environment to work with Terraform and cloud providers (AWS, Azure, GCP). Follow these steps before attempting the labs.

## 1. Install Terraform

Terraform is the primary tool we'll use throughout these labs.

### For Windows:

1. Download the Windows binary from the [Terraform Downloads page](https://developer.hashicorp.com/terraform/downloads)
2. Extract the downloaded zip file to a directory, e.g., `C:\terraform`
3. Add this directory to your system's PATH:
   - Search for "Environment Variables" in Windows search
   - Click "Edit the system environment variables"
   - Click "Environment Variables"
   - Under "System variables", find "Path" and click "Edit"
   - Click "New" and add the path to your Terraform directory (e.g., `C:\terraform`)
   - Click "OK" on all dialogs
4. Verify the installation by opening a new PowerShell window and typing:
   ```powershell
   terraform --version
   ```

### For macOS:

Using Homebrew:
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform --version
```

### For Linux:

Using package manager (Ubuntu/Debian):
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
terraform --version
```

## 2. Install Git

Git is essential for version control and working with the lab files.

### For Windows:

1. Download Git from [git-scm.com](https://git-scm.com/download/win)
2. Run the installer, using default options
3. Verify installation by opening a new PowerShell window and typing:
   ```powershell
   git --version
   ```

### For macOS:

Using Homebrew:
```bash
brew install git
git --version
```

### For Linux:

```bash
sudo apt-get update && sudo apt-get install git
git --version
```

## 3. Set Up Code Editor

We recommend using Visual Studio Code for these labs, as it offers excellent Terraform support.

1. Download and install [Visual Studio Code](https://code.visualstudio.com/)
2. Install the following extensions:
   - HashiCorp Terraform (`hashicorp.terraform`)
   - Terraform (`4ops.terraform`)
   - YAML (`redhat.vscode-yaml`)

## 4. Clone the Repository

Clone this repository to your local machine:

```bash
git clone https://github.com/<your-org>/terraform-labs.git
cd terraform-labs
```

## 5. Cloud Provider Setup

### AWS Setup

1. [Create an AWS account](https://aws.amazon.com/) if you don't have one
2. Create an IAM User with programmatic access:
   - Sign in to the AWS Management Console
   - Navigate to IAM (Identity and Access Management)
   - Click "Users" then "Add user"
   - Enter a username and select "Programmatic access"
   - Attach the "AdministratorAccess" policy (for learning purposes only - use more restricted permissions in production)
   - Complete the user creation and download the credentials CSV file
3. Configure AWS CLI:
   ```bash
   # Install AWS CLI
   # For Windows: Download and run the installer from https://aws.amazon.com/cli/
   # For macOS:
   brew install awscli
   # For Linux:
   pip install awscli
   
   # Configure AWS CLI
   aws configure
   # Enter your Access Key ID and Secret Access Key when prompted
   # Set default region to eu-west-1
   # Set output format to json
   ```

### Azure Setup

1. [Create an Azure account](https://azure.microsoft.com/free/) if you don't have one
2. Install Azure CLI:
   ```bash
   # For Windows: Download and run the installer from https://docs.microsoft.com/cli/azure/install-azure-cli-windows
   # For macOS:
   brew install azure-cli
   # For Linux:
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```
3. Sign in to Azure:
   ```bash
   az login
   ```
4. If you have multiple subscriptions, set your active subscription:
   ```bash
   # List your subscriptions
   az account list --output table
   
   # Set your active subscription
   az account set --subscription "your-subscription-id"
   ```

### GCP Setup

1. [Create a GCP account](https://cloud.google.com/) if you don't have one
2. Create a new project in the GCP Console
3. Install Google Cloud SDK:
   - For Windows: Download and run the installer from [cloud.google.com/sdk](https://cloud.google.com/sdk/docs/install)
   - For macOS: `brew install --cask google-cloud-sdk`
   - For Linux: Follow the instructions at [cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)
4. Initialize the SDK and authenticate:
   ```bash
   gcloud init
   # Follow the prompts to select your GCP project
   ```
5. Create a service account and download credentials:
   - Navigate to IAM & Admin > Service Accounts in the GCP Console
   - Click "Create Service Account"
   - Give it a name and grant it the "Owner" role (for learning purposes only)
   - Create a key (JSON) and download it
   - Set the environment variable:
     ```bash
     # For Windows PowerShell:
     $env:GOOGLE_APPLICATION_CREDENTIALS="path\to\your\credentials.json"
     
     # For macOS/Linux:
     export GOOGLE_APPLICATION_CREDENTIALS="path/to/your/credentials.json"
     ```

## 6. Terraform Cloud Setup (For Advanced Labs)

1. [Create a Terraform Cloud account](https://app.terraform.io/signup/account) if you don't have one
2. Create an organization or join an existing one
3. Create a user API token:
   - Click on your user icon in the top right
   - Go to "User Settings"
   - Navigate to "Tokens"
   - Click "Create an API token"
   - Give it a description and create the token
   - Save this token securely as it will only be shown once
4. Configure Terraform CLI to use your token:
   ```bash
   terraform login
   # Enter your API token when prompted
   ```

## 7. Testing Your Setup

Test that everything is set up correctly:

1. Open a terminal/command prompt
2. Navigate to a lab directory (e.g., `cd AWS/LAB01-EC2-Instance`)
3. Run `terraform init` to ensure Terraform can initialize and connect to your provider

## Troubleshooting

### Common Issues:

1. **"terraform not found" error**: Make sure the Terraform binary is in your PATH
2. **AWS authentication issues**: Check your AWS credentials are set correctly in `~/.aws/credentials`
3. **Azure login problems**: Run `az account show` to check if you're logged in properly
4. **GCP authentication errors**: Verify the `GOOGLE_APPLICATION_CREDENTIALS` path is correct

### Getting Help:

- Check the [Terraform documentation](https://developer.hashicorp.com/terraform/docs)
- Refer to the specific cloud provider's documentation
- Post your issue in the course discussion forum

## Next Steps

Once your environment is set up, you're ready to begin the labs! Start with the first lab in your preferred cloud provider folder:

- AWS: `LAB01-EC2-Instance`
- Azure: `LAB01-Virtual-Machine`
- GCP: `LAB01-Compute-Engine`

Each lab contains a README with step-by-step instructions and explains the concepts being covered.

---

Happy Terraforming! 