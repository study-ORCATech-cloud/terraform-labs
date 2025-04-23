# Common Networking Module

This Terraform module creates network infrastructure across multiple cloud providers (AWS, Azure, GCP) with a consistent interface.

## Features

- Creates VPC/VNet/VPC Network based on the chosen provider
- Creates a subnet within the network
- Applies consistent naming and tagging across providers
- Outputs consistent resource identifiers regardless of provider

## Usage

```hcl
module "network" {
  source = "../../Common/modules/networking"
  
  provider_type      = "aws"  # One of: aws, azure, gcp
  network_name       = "my-network"
  cidr_block         = "10.0.0.0/16"
  subnet_cidr        = "10.0.1.0/24"
  location           = "us-east-1"
  resource_group_name = "my-rg"  # Only required for Azure
  
  tags = {
    Environment = "lab"
    Owner       = "terraform"
  }
}
```

## Input Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| provider_type | The cloud provider to use (aws, azure, or gcp) | string | "aws" | no |
| network_name | Name for the network resources | string | "terraform-network" | no |
| cidr_block | CIDR block for the network | string | "10.0.0.0/16" | no |
| subnet_cidr | CIDR block for the subnet | string | "10.0.1.0/24" | no |
| location | Region/location for the cloud resources | string | "us-east-1" | no |
| resource_group_name | Name of the Azure resource group (only used for Azure) | string | "" | no |
| tags | Tags to apply to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| network_id | ID of the created network |
| subnet_id | ID of the created subnet |
| network_name | Name of the created network |
| subnet_cidr | CIDR block of the created subnet |

## Examples

### AWS Example

```hcl
module "aws_network" {
  source = "../../Common/modules/networking"
  
  provider_type = "aws"
  network_name  = "aws-lab-network"
  cidr_block    = "10.0.0.0/16"
  subnet_cidr   = "10.0.1.0/24"
  location      = "us-east-1"
  
  tags = {
    Environment = "lab"
    Cloud       = "AWS"
  }
}
```

### Azure Example

```hcl
module "azure_network" {
  source = "../../Common/modules/networking"
  
  provider_type       = "azure"
  network_name        = "azure-lab-network"
  cidr_block          = "10.0.0.0/16"
  subnet_cidr         = "10.0.1.0/24"
  location            = "eastus"
  resource_group_name = "my-resource-group"
  
  tags = {
    Environment = "lab"
    Cloud       = "Azure"
  }
}
```

### GCP Example

```hcl
module "gcp_network" {
  source = "../../Common/modules/networking"
  
  provider_type = "gcp"
  network_name  = "gcp-lab-network"
  cidr_block    = "10.0.0.0/16"  # Not directly used in GCP
  subnet_cidr   = "10.0.1.0/24"
  location      = "us-central1"
  
  tags = {
    Environment = "lab"
    Cloud       = "GCP"
  }
} 