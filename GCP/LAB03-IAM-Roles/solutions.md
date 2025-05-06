# LAB03: IAM Roles and Service Accounts Solutions

This document provides solutions for the IAM Roles and Service Accounts lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_project_iam_custom_role" "custom_role" {
  role_id     = var.custom_role_id
  title       = "Custom Terraform Role"
  description = "Custom role created via Terraform"
  permissions = var.custom_role_permissions
  stage       = "GA"
}

resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = "Terraform Managed Service Account"
  description  = "Service account for read-only operations created by Terraform"
}

resource "google_project_iam_member" "custom_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.custom_role.id
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "storage_viewer_binding" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "conditional_logging_binding" {
  count   = var.enable_conditional_binding ? 1 : 0
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
  
  condition {
    title       = var.conditional_title
    description = var.conditional_description
    expression  = var.conditional_expression
  }
}
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}
```

This configures the Google Cloud provider with your project ID and region. These values are passed from variables, allowing flexibility across different environments.

### 2. Create a Custom IAM Role

```terraform
resource "google_project_iam_custom_role" "custom_role" {
  role_id     = var.custom_role_id
  title       = "Custom Terraform Role"
  description = "Custom role created via Terraform"
  permissions = var.custom_role_permissions
  stage       = "GA"
}
```

This creates a custom IAM role at the project level with:

- **role_id**: A unique identifier for the role (must be unique within the project)
- **title**: A human-readable name for the role
- **description**: Explains the purpose of the role
- **permissions**: The specific GCP permissions granted by this role
- **stage**: The launch stage of the role (GA = Generally Available)

Custom roles are useful when predefined roles don't match your exact permission requirements, allowing you to implement least privilege access.

### 3. Create a Service Account

```terraform
resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = "Terraform Managed Service Account"
  description  = "Service account for read-only operations created by Terraform"
}
```

This creates a service account that can be used by applications or services to authenticate with Google Cloud. The service account:

- Has a unique account_id within the project
- Includes a human-readable display name 
- Contains a description explaining its purpose
- Will be used for read-only operations

Service accounts are identities for workloads (not humans) and are ideal for automated processes.

### 4. Assign the Custom Role to the Service Account

```terraform
resource "google_project_iam_member" "custom_role_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.custom_role.id
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
```

This creates an IAM binding that:

- Associates the custom role with the service account
- Applies at the project level
- Uses the format "serviceAccount:EMAIL" for the member field

This binding grants the service account all permissions defined in the custom role.

### 5. Assign a Predefined Role to the Service Account

```terraform
resource "google_project_iam_member" "storage_viewer_binding" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
```

This creates another IAM binding that:

- Assigns the predefined "storage.objectViewer" role to the service account
- Applies at the project level
- Grants read-only access to objects in Cloud Storage buckets

Using predefined roles is convenient for common permission sets.

### 6. Create a Conditional IAM Binding (Optional)

```terraform
resource "google_project_iam_member" "conditional_logging_binding" {
  count   = var.enable_conditional_binding ? 1 : 0
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.service_account.email}"
  
  condition {
    title       = var.conditional_title
    description = var.conditional_description
    expression  = var.conditional_expression
  }
}
```

This conditionally creates an IAM binding that:

- Only gets created if enable_conditional_binding is true (using the count parameter)
- Assigns the "logging.viewer" role to the service account
- Includes a condition that limits when the permissions are granted
- The example condition restricts access to before 2024

Conditional bindings add an extra layer of security by restricting when or where permissions apply.

## Variables and Outputs

### Important Variables

- **project_id**: Your Google Cloud project identifier
- **custom_role_id**: ID for the custom role (must be unique)
- **custom_role_permissions**: List of permissions for the custom role
- **service_account_name**: Name for the service account

### Key Outputs

- **service_account_email**: Email address of the service account
- **custom_role_id**: ID of the created custom role
- **gcloud commands**: Ready-to-use commands for verification

## Common Issues and Solutions

1. **Permission denied**: Ensure your account has the IAM Admin role
2. **Role already exists**: Custom role IDs must be unique; try a different name
3. **Invalid permissions**: Verify all permissions are valid and correctly formatted
4. **Condition errors**: CEL expressions must be valid; check syntax carefully

## Advanced Customizations

For more complex IAM configurations, consider:

1. Organization-level roles and bindings:
```terraform
resource "google_organization_iam_custom_role" "org_role" {
  org_id      = "your-org-id"
  role_id     = "customOrgRole"
  title       = "Custom Organization Role"
  permissions = ["compute.instances.list", "storage.buckets.list"]
}
```

2. Using IAM policy data sources for more complex policies:
```terraform
data "google_iam_policy" "admin" {
  binding {
    role    = "roles/editor"
    members = ["user:jane@example.com"]
  }
  
  binding {
    role    = "roles/viewer"
    members = ["group:viewers@example.com"]
  }
}

resource "google_project_iam_policy" "project" {
  project     = var.project_id
  policy_data = data.google_iam_policy.admin.policy_data
}
```

3. Creating service account keys (use cautiously):
```terraform
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.service_account.name
}
``` 