# LAB10: Cloud Functions with HTTP Trigger Solutions

This document provides solutions for the Cloud Functions HTTP Trigger lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable the Cloud Functions API
resource "google_project_service" "cloudfunctions_api" {
  service                    = "cloudfunctions.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Enable the Cloud Build API (required for Cloud Functions deployment)
resource "google_project_service" "cloudbuild_api" {
  service                    = "cloudbuild.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Create a Cloud Storage bucket for function code
resource "google_storage_bucket" "function_bucket" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
  labels                      = var.labels

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_project_service.cloudbuild_api
  ]
}

# Create a Cloud Storage bucket object for the function code archive
resource "google_storage_bucket_object" "function_archive" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "${path.module}/function.zip"
}

# Create a Cloud Function with HTTP trigger
resource "google_cloudfunctions_function" "function" {
  name                  = var.function_name
  description           = "HTTP Cloud Function for lab demonstration"
  runtime               = var.function_runtime
  available_memory_mb   = var.function_memory
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_archive.name
  timeout               = var.function_timeout
  entry_point           = var.function_entry_point
  labels                = var.labels
  
  # Scaling settings
  min_instances = var.function_min_instances
  max_instances = var.function_max_instances

  # HTTP Trigger
  trigger_http = true

  # Environment variables (if provided)
  dynamic "environment_variables" {
    for_each = length(var.function_environment_variables) > 0 ? [1] : []
    content {
      variables = var.function_environment_variables
    }
  }

  # Service account (if provided)
  service_account_email = var.function_service_account_email != "" ? var.function_service_account_email : null

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_project_service.cloudbuild_api
  ]
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  count          = var.allow_unauthenticated ? 1 : 0
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
```

## Function Code Solution

Below is the Python function code in `function-code/main.py`:

```python
import functions_framework
from flask import escape

@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response
    """
    # Get the name parameter from the request
    request_args = request.args
    name = request_args.get('name', 'World')
    
    # Return a response with the name parameter
    return f'Hello {escape(name)} from Cloud Functions!'
```

And here's the `requirements.txt` file:

```
functions-framework==3.0.0
flask==2.0.1
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}
```

This configures the Google Cloud provider with your project ID and region. Using variables allows flexibility across different environments.

### 2. Enable Required APIs

```terraform
resource "google_project_service" "cloudfunctions_api" {
  service                    = "cloudfunctions.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "cloudbuild_api" {
  service                    = "cloudbuild.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}
```

This enables two required APIs:
- **Cloud Functions API**: To create and manage Cloud Functions
- **Cloud Build API**: Required for deploying Cloud Functions (builds the function package)

The resources:
- Specify the API services to enable
- Set `disable_on_destroy` to true to disable the APIs when you run `terraform destroy`
- Set custom timeouts to allow for API activation, which can take time
- Disable dependent services when destroying to prevent orphaned resources

### 3. Create a Storage Bucket for Function Code

```terraform
resource "google_storage_bucket" "function_bucket" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true

  uniform_bucket_level_access = true
  labels                      = var.labels

  depends_on = [
    google_project_service.cloudfunctions_api,
    google_project_service.cloudbuild_api
  ]
}
```

This creates a Cloud Storage bucket to store the function code:
- Sets a globally unique bucket name
- Configures the location (region or multi-region)
- Sets `force_destroy` to true to allow Terraform to delete the bucket even if it contains objects
- Enables uniform bucket-level access for better security
- Applies labels for resource organization
- Depends on the APIs being enabled

### 4. Upload Function Code

```terraform
resource "google_storage_bucket_object" "function_archive" {
  name   = "function.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "${path.module}/function.zip"
}
```

This uploads the function code to the storage bucket:
- Sets a name for the object ("function.zip")
- References the storage bucket we created
- Sets the source to the local zip file containing the function code
- The `path.module` expression refers to the directory containing the Terraform configuration

### 5. Create the Cloud Function

```terraform
resource "google_cloudfunctions_function" "function" {
  name                  = var.function_name
  description           = "HTTP Cloud Function for lab demonstration"
  runtime               = var.function_runtime
  available_memory_mb   = var.function_memory
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_archive.name
  timeout               = var.function_timeout
  entry_point           = var.function_entry_point
  labels                = var.labels
  
  # Scaling settings
  min_instances = var.function_min_instances
  max_instances = var.function_max_instances

  # HTTP Trigger
  trigger_http = true

  # ... other settings ...
}
```

This creates the Cloud Function with an HTTP trigger:
- Sets the function name and description
- Configures the runtime (e.g., Python 3.10)
- Sets memory allocation for the function
- Points to the uploaded code archive
- Sets the timeout in seconds
- Specifies the entry point (function name in the code)
- Sets `trigger_http` to true to create an HTTP endpoint
- Configures scaling settings to control instance count
- Sets labels for organization

### 6. Configure Function Environment Variables (Conditional)

```terraform
dynamic "environment_variables" {
  for_each = length(var.function_environment_variables) > 0 ? [1] : []
  content {
    variables = var.function_environment_variables
  }
}
```

This dynamically adds environment variables to the function if any are provided:
- Uses a dynamic block that only executes if the environment variables map is not empty
- Sets all provided environment variables in one block

### 7. Configure Public Access (Optional)

```terraform
resource "google_cloudfunctions_function_iam_member" "invoker" {
  count          = var.allow_unauthenticated ? 1 : 0
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
```

This conditionally grants public access to invoke the function:
- Only creates the IAM binding if `allow_unauthenticated` is true
- Grants the "cloudfunctions.invoker" role to "allUsers" (making the function public)
- References the specific function using its name, project, and region

## Creating the Function Archive

To create the function archive, you can use the following steps:

1. Create a directory with your function code and dependencies:
```
mkdir -p function-code
cd function-code
```

2. Create the function code (main.py and requirements.txt)

3. Create a zip archive:
```
cd function-code
zip -r ../function.zip .
```

## Variables and Outputs

### Important Variables

- **function_name**: The name of your Cloud Function
- **function_runtime**: The runtime environment (e.g., Python 3.10)
- **function_entry_point**: The name of the function in your code
- **allow_unauthenticated**: Controls whether the function is publicly accessible

### Key Outputs

- **function_url**: The HTTPS URL to access the deployed function
- **curl_command**: An example curl command to test the function
- **browser_link**: A link that can be opened in a browser to test the function

## Testing the Function

After applying the Terraform configuration, you can test the function using:

1. **Browser**: Open the URL from the `browser_link` output
2. **Curl**: Run the command from the `curl_command` output
3. **Console**: Click the URL from the `console_url` output to view the function in the GCP Console

## Common Issues and Solutions

1. **Missing API**: Ensure both the Cloud Functions API and Cloud Build API are enabled
2. **Function returns 403**: Check if you set `allow_unauthenticated = true` to allow public access
3. **Function fails to deploy**: Verify that the function code is valid and the entry point matches
4. **Zip file issues**: Make sure the zip file contains all required files at the root level (not in a subdirectory)

## Advanced Customizations

For more complex deployments, consider:

1. Securing the function with authentication:
```terraform
# Set allow_unauthenticated = false in variables
# Then grant access to specific users/groups
resource "google_cloudfunctions_function_iam_member" "specific_invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "user:jane@example.com"
}
```

2. Adding VPC connectivity for the function:
```terraform
resource "google_cloudfunctions_function" "advanced_function" {
  # ... existing configuration ...
  
  vpc_connector = "projects/${var.project_id}/locations/${var.region}/connectors/my-vpc-connector"
  
  vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
}
```

3. Creating event-triggered functions instead of HTTP triggers:
```terraform
resource "google_cloudfunctions_function" "pubsub_function" {
  # ... existing configuration ...
  
  # Remove trigger_http = true
  
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = "projects/${var.project_id}/topics/my-topic"
  }
}
``` 