# LAB10: Deploy an Azure Function with HTTP Trigger using Terraform

## 📝 Lab Overview

In this lab, you'll build and deploy a serverless **Azure Function** that responds to **HTTP requests**, using **Terraform**. You'll also set up necessary resources like App Service Plans and Storage Accounts.

---

## 🎯 Objectives

- Create an Azure Function App with HTTP trigger
- Deploy code using Terraform and zip package
- Access and invoke function via public URL

---

## 🧰 Prerequisites

- Azure subscription
- Terraform v1.3+ and Azure CLI installed (`az login`)
- A zip file containing your function (Node.js, Python, C# supported)

---

## 📁 File Structure

```bash
Azure/LAB10-Functions-HTTPTrigger/
├── main.tf               # Function App, Plan, Storage
├── variables.tf          # Runtime, region, function name
├── outputs.tf            # Function URL
├── terraform.tfvars      # Optional overrides
├── function-code/        # Function source code
│   ├── function_app.py   # Python function (example)
│   ├── host.json         # Function host configuration
│   └── requirements.txt  # Python dependencies
├── function.zip          # Deployment package (you'll create this)
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Review the TODO Tasks in main.tf**

   You'll need to implement the following resources:
   - Resource Group for Function resources
   - Storage Account for Function App
   - Service Plan (Consumption plan)
   - Application Insights (optional but recommended)
   - Function App (Linux or Windows based on your preference)
   - Function deployment using zip package

2. **Prepare your code and zip it**
```bash
cd function-code
zip -r ../function.zip .
```

3. **Initialize and apply Terraform**
```bash
terraform init
terraform apply
```

4. **Test function in browser or with curl**
```bash
# For anonymous functions:
curl $(terraform output -raw function_url)?name=Terraform

# For functions with authentication:
curl "$(terraform output -raw function_url)?code=<function_key>&name=Terraform"
```

---

## 🧼 Cleanup

```bash
terraform destroy
```
Deletes the Function App, Storage, and Plan

---

## 💡 Key Concepts

- **Function App**: Hosts the serverless code
- **App Service Plan**: Required for consumption or premium tiers
- **Zip Deploy**: Uploads and activates code via archive
- **Function Authentication**: Control access with function keys or anonymous access

---

## 🧪 Optional Challenges

- Add environment variables and application settings
- Add authentication using Azure AD or function keys
- Log output to Azure Monitor
- Create a custom domain for your Function App
- Implement VNet integration for your Function App

---

## 📚 References

- [Terraform Azure Function Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app)
- [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/)
- [Python Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference-python)

---

## ✅ Summary

You've now deployed a lightweight, event-driven HTTP function in Azure using Terraform. This is foundational for serverless automation, APIs, and event pipelines.

