# Common Terraform Modules and Configurations

This directory contains reusable Terraform modules and configurations that can be used across different cloud providers.

## Purpose

The Common directory provides:
- Shared Terraform modules that abstract common infrastructure patterns
- Reusable configurations that work across multiple cloud providers
- Helper scripts and utilities for Terraform workflows

## Available Modules

This section will be updated as modules are added to the repository.

## Usage

To use a module from this directory in your lab exercises:

```hcl
module "example" {
  source = "../../Common/modules/example"
  
  # Module parameters
  param1 = "value1"
  param2 = "value2"
}
```

Refer to each module's README for specific usage instructions and parameters. 