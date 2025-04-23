# Terraform Labs Repository

A comprehensive collection of hands-on Terraform labs for learning Infrastructure as Code (IaC) across multiple cloud platforms including AWS, Azure, and GCP.

## Repository Overview

This repository contains structured labs designed to help you learn Terraform through practical, hands-on exercises. Each cloud provider has its own directory with labs progressing from basic to advanced concepts.

## Repository Structure

```
terraform-labs/
│
├── AWS/              # AWS-focused Terraform labs
│   ├── LAB01/       # Basic AWS resources
│   ├── LAB02/       # (Coming soon)
│   └── ...
│
├── Azure/           # Azure-focused Terraform labs
│   ├── LAB01/       # (Coming soon)
│   └── ...
│
├── GCP/             # Google Cloud Platform labs
│   ├── LAB01/       # (Coming soon)
│   └── ...
│
└── Common/          # Common modules and configurations
    └── ...
```

## Getting Started

### Prerequisites

To use these labs, you'll need:

- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0 or newer recommended)
- Accounts for the cloud providers you want to work with
- Cloud provider CLI tools installed and configured:
  - AWS: [AWS CLI](https://aws.amazon.com/cli/)
  - Azure: [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
  - GCP: [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)

### How to Use These Labs

1. Clone this repository to your local machine
2. Navigate to the specific lab directory you're interested in
3. Follow the instructions in each lab's README.md file
4. Execute the terraform commands as directed in the lab instructions

Each lab contains:
- Terraform configuration files (*.tf)
- README.md with step-by-step instructions
- Optional challenge exercises to enhance your learning

## Learning Path

The labs within each cloud provider directory follow a natural progression:

1. **Fundamentals**: Basic resource creation, variables, outputs
2. **Intermediate**: Modules, state management, complex resources
3. **Advanced**: Remote state, workspaces, CI/CD integration

## Contributing

Contributions to this repository are welcome! If you'd like to add new labs or improve existing ones, please follow the standard GitHub workflow:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Acknowledgments

- Terraform documentation and community
- Cloud provider documentation and examples