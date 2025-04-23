# LAB10: Deploy Cloud Function with HTTP Trigger using Terraform

## 📝 Lab Overview

In this lab, you’ll use **Terraform** to deploy a serverless **Cloud Function** that responds to **HTTP events**. This enables lightweight microservices or automation logic without managing infrastructure.

---

## 🎯 Objectives

- Deploy a Cloud Function with HTTP trigger
- Use a zip archive to upload source code
- Invoke function via curl or browser

---

## 🧰 Prerequisites

- GCP project with Cloud Functions API enabled
- Terraform v1.3+ installed
- `gcloud` CLI authenticated

---

## 📁 File Structure

```bash
GCP/LAB10-CloudFunctions-HTTP/
├── main.tf               # Function config and HTTP trigger
├── variables.tf          # Function name, entry point, etc.
├── outputs.tf            # Function URL
├── function.zip          # Zipped function code
├── terraform.tfvars      # Optional overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Prepare function code**
```bash
cd function-code
zip -r ../function.zip .
```

2. **Deploy the function**
```bash
terraform init
terraform apply
```

3. **Test the endpoint**
```bash
curl $(terraform output -raw function_url)?name=GCP
```

---

## 🧼 Cleanup

```bash
terraform destroy
```
This deletes the function and its resources

---

## 💡 Key Concepts

- **Cloud Function**: Serverless compute unit that runs on demand
- **Trigger**: HTTP event binding that invokes the function
- **Entry Point**: The handler within your source code

---

## 🧪 Optional Challenges

- Add environment variables
- Secure endpoint using IAM or API key
- Log output to Cloud Logging

---

## 📚 References

- [Terraform Cloud Function Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function)
- [GCP Cloud Functions](https://cloud.google.com/functions/)

---

## ✅ Summary

You’ve deployed your first serverless HTTP-based Cloud Function with Terraform. This is foundational for modern event-driven and microservice architectures.

Congratulations on completing LAB10!

