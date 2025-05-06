# LAB10: Azure Functions with HTTP Trigger Solution

This document provides solutions for the Azure Functions with HTTP Trigger lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Get current subscription for outputs
data "azurerm_subscription" "current" {}

# Create a Resource Group for Function App resources
resource "azurerm_resource_group" "function_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a Storage Account for Function App
resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.function_rg.name
  location                 = azurerm_resource_group.function_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Create a Service Plan for Function App
resource "azurerm_service_plan" "function_plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  os_type             = var.os_type
  sku_name            = "Y1" # Consumption plan
  tags                = var.tags
}

# Create an Application Insights instance
resource "azurerm_application_insights" "insights" {
  name                = var.app_insights_name
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  application_type    = "web"
  tags                = var.tags
}

# Create a Linux Function App
resource "azurerm_linux_function_app" "function_app" {
  count               = var.os_type == "Linux" ? 1 : 0
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.function_plan.id
  
  https_only = true
  
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
    "FUNCTIONS_WORKER_RUNTIME"       = var.function_runtime
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
  }
  
  site_config {
    application_stack {
      dynamic "python" {
        for_each = var.function_runtime == "python" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
      
      dynamic "node" {
        for_each = var.function_runtime == "node" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
      
      dynamic "dotnet" {
        for_each = var.function_runtime == "dotnet" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
    }
  }
  
  tags = var.tags
}

# Create a Windows Function App
resource "azurerm_windows_function_app" "function_app" {
  count               = var.os_type == "Windows" ? 1 : 0
  name                = var.function_app_name
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  
  storage_account_name       = azurerm_storage_account.function_storage.name
  storage_account_access_key = azurerm_storage_account.function_storage.primary_access_key
  service_plan_id            = azurerm_service_plan.function_plan.id
  
  https_only = true
  
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "1"
    "FUNCTIONS_WORKER_RUNTIME"       = var.function_runtime
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.insights.instrumentation_key
  }
  
  site_config {
    application_stack {
      dynamic "python" {
        for_each = var.function_runtime == "python" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
      
      dynamic "node" {
        for_each = var.function_runtime == "node" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
      
      dynamic "dotnet" {
        for_each = var.function_runtime == "dotnet" ? [1] : []
        content {
          version = var.function_runtime_version
        }
      }
    }
  }
  
  tags = var.tags
}

# Deploy the Function Code using a null resource and Azure CLI
# This approach allows for more flexibility in deployment
resource "null_resource" "function_deploy" {
  depends_on = [
    azurerm_linux_function_app.function_app,
    azurerm_windows_function_app.function_app
  ]
  
  # Only deploy if the zip file exists
  triggers = {
    zip_file_exists = fileexists(var.zip_deploy_file) ? "true" : "false"
  }
  
  # Use local-exec provisioner to deploy the zip package
  provisioner "local-exec" {
    command = <<EOF
      az functionapp deployment source config-zip \
        --resource-group ${azurerm_resource_group.function_rg.name} \
        --name ${var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].name : azurerm_windows_function_app.function_app[0].name} \
        --src ${var.zip_deploy_file}
    EOF
  }
}
```

## Creating Sample Function Code

To help students get started with the lab, you can provide them with a simple HTTP-triggered function for either Python, Node.js, or .NET. Below are the sample implementations for each runtime:

### Python Sample (function_app.py)

```python
import logging
import azure.functions as func

app = func.FunctionApp()

@app.route(route="HttpTrigger", auth_level=func.AuthLevel.FUNCTION)
def http_trigger(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
            name = req_body.get('name')
        except ValueError:
            pass

    if name:
        return func.HttpResponse(f"Hello, {name}! Welcome to Azure Functions with Terraform.")
    else:
        return func.HttpResponse(
            "Please pass a name on the query string or in the request body",
            status_code=400
        )
```

### Node.js Sample (index.js)

```javascript
module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    const name = (req.query.name || (req.body && req.body.name));
    const responseMessage = name
        ? "Hello, " + name + "! Welcome to Azure Functions with Terraform."
        : "Please pass a name on the query string or in the request body";

    context.res = {
        // status: 200, /* Defaults to 200 */
        body: responseMessage
    };
}
```

### .NET Sample (HttpTrigger.cs)

```csharp
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace Company.Function
{
    public static class HttpTrigger
    {
        [FunctionName("HttpTrigger")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;

            return name != null
                ? (ActionResult)new OkObjectResult($"Hello, {name}! Welcome to Azure Functions with Terraform.")
                : new BadRequestObjectResult("Please pass a name on the query string or in the request body");
        }
    }
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Provider

```terraform
provider "azurerm" {
  features {}
}
```

This configures the Azure Resource Manager provider. The empty `features {}` block is required.

### 2. Create a Resource Group

```terraform
resource "azurerm_resource_group" "function_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group to contain all function-related resources. Resource groups are logical containers for Azure resources.

### 3. Create a Storage Account

```terraform
resource "azurerm_storage_account" "function_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.function_rg.name
  location                 = azurerm_resource_group.function_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}
```

Functions require a storage account for internal operations, such as managing triggers and storing function execution logs.

### 4. Create a Service Plan

```terraform
resource "azurerm_service_plan" "function_plan" {
  name                = var.service_plan_name
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  os_type             = var.os_type
  sku_name            = "Y1" # Consumption plan
  tags                = var.tags
}
```

The service plan defines the compute resources allocated to the function app. The "Y1" SKU represents a consumption plan, which is ideal for serverless architectures due to its pay-per-execution model.

### 5. Create an Application Insights Instance

```terraform
resource "azurerm_application_insights" "insights" {
  name                = var.app_insights_name
  resource_group_name = azurerm_resource_group.function_rg.name
  location            = azurerm_resource_group.function_rg.location
  application_type    = "web"
  tags                = var.tags
}
```

Application Insights provides monitoring and diagnostics for the function app, including request rates, failure rates, and performance metrics.

### 6. Create a Function App

```terraform
resource "azurerm_linux_function_app" "function_app" {
  count               = var.os_type == "Linux" ? 1 : 0
  # configuration...
}

resource "azurerm_windows_function_app" "function_app" {
  count               = var.os_type == "Windows" ? 1 : 0
  # configuration...
}
```

This creates the function app resource, which will host the function code. Note that we use a count conditional to create either a Linux or Windows function app based on the `os_type` variable.

### 7. Deploy the Function Code

```terraform
resource "null_resource" "function_deploy" {
  # configuration...
  provisioner "local-exec" {
    command = <<EOF
      az functionapp deployment source config-zip \
        --resource-group ${azurerm_resource_group.function_rg.name} \
        --name ${var.os_type == "Linux" ? azurerm_linux_function_app.function_app[0].name : azurerm_windows_function_app.function_app[0].name} \
        --src ${var.zip_deploy_file}
    EOF
  }
}
```

This uses a `null_resource` with a `local-exec` provisioner to deploy the function code using the Azure CLI. The function code is packaged in a zip file and deployed using the `az functionapp deployment source config-zip` command.

## Testing the Function

After deploying the function, students can test it using:

```bash
# For anonymous auth level
curl "https://<function-app-name>.azurewebsites.net/api/HttpTrigger?name=Student"

# For function auth level
curl "https://<function-app-name>.azurewebsites.net/api/HttpTrigger?code=<function-key>&name=Student"
```

## Common Issues and Solutions

1. **Storage Account Name Uniqueness**: Storage account names must be globally unique. If deployment fails, try a different name.

2. **Function App Name Uniqueness**: Function app names must be globally unique. If deployment fails, try a different name.

3. **Function Runtime Compatibility**: Ensure the chosen runtime (Python, Node.js, .NET) and version are compatible with the OS type (Linux or Windows).

4. **ZIP Package Structure**: The ZIP package must follow the specific structure expected by the function runtime. For example, Python functions should include a `function_app.py` file.

5. **Auth Level**: If you're receiving 401 Unauthorized errors, check the auth level of your function. If it's set to "function", you need to include a function key in your requests.

## Advanced Configurations

For more advanced scenarios, students can:

1. **Configure CORS**: Allow cross-origin requests to the function

2. **Add Custom Domains**: Map a custom domain to the function app

3. **Set Up VNet Integration**: Connect the function app to a virtual network

4. **Configure Managed Identity**: Use managed identity for secure access to other Azure resources

5. **Implement Azure Key Vault Integration**: Store secrets securely

## Best Practices for Azure Functions

1. **Use Proper Error Handling**: Implement try-catch blocks and proper logging

2. **Keep Functions Small and Focused**: Each function should do one thing well

3. **Use Dependency Injection**: For better testability and maintainability

4. **Optimize Cold Start**: Minimize dependencies and code size

5. **Implement Proper Security**: Use appropriate authentication levels and secure storage for secrets

6. **Monitor Performance**: Use Application Insights to monitor function performance

## Additional Resources

Refer students to these helpful resources:

1. Azure Functions documentation: https://docs.microsoft.com/en-us/azure/azure-functions/

2. Terraform Azure Function documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app

3. Function best practices: https://docs.microsoft.com/en-us/azure/azure-functions/functions-best-practices 