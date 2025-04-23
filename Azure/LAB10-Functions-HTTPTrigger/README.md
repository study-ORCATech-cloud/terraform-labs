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
├── function.zip          # Deployment package
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Prepare your code and zip it**
```bash
cd function-code
zip -r ../function.zip .
```

2. **Initialize and apply Terraform**
```bash
terraform init
terraform apply
```

3. **Test function in browser or with curl**
```bash
curl $(terraform output -raw function_url)?name=Terraform
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

---

## 🧪 Optional Challenges

- Add environment variables and application settings
- Add authentication using Azure AD or function keys
- Log output to Azure Monitor

---

## 📚 References

- [Terraform Azure Function Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app)
- [Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/)

---

## ✅ Summary

You've now deployed a lightweight, event-driven HTTP function in Azure using Terraform. This is foundational for serverless automation, APIs, and event pipelines.

