# LAB10: Deploy Serverless Function with Lambda and API Gateway using Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to provision an **AWS Lambda function** and expose it through **API Gateway**. This is the foundation of serverless application architecture, letting you run code without managing servers.

---

## 🎯 Objectives

- Create a Lambda function with IAM execution role
- Configure API Gateway to route HTTP requests
- Deploy a test endpoint and invoke it via browser or `curl`

---

## 🧰 Prerequisites

- Terraform v1.3+ installed
- AWS CLI configured
- `zip` installed to package Lambda function
- Sample Lambda handler code (e.g. `index.js`, `main.py`, etc.)

---

## 📁 File Structure

```bash
AWS/LAB10-Lambda/
├── main.tf               # Lambda, IAM, API Gateway setup
├── variables.tf          # Function name, runtime, etc.
├── outputs.tf            # API URL
├── lambda/               # Function source code
│   └── index.js          # Or `main.py` based on runtime
├── terraform.tfvars      # Optional overrides
└── README.md             # This file
```

---

## 🚀 Steps to Complete the Lab

1. **Zip the Lambda code**
   ```bash
   cd lambda && zip ../function.zip index.js
   cd ..
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Plan and apply**
   ```bash
   terraform plan
   terraform apply
   ```

4. **Test endpoint**
   ```bash
   curl $(terraform output -raw api_url)
   ```

---

## 🧼 Cleanup

```bash
terraform destroy
```
To remove Lambda, IAM role, and API Gateway

---

## 💡 Key Concepts

- **Lambda Function**: Serverless code triggered by HTTP
- **IAM Role**: Grants function permissions to run
- **API Gateway**: Public endpoint to trigger Lambda
- **Deployment Stage**: Named environment for routing

---

## 🧪 Optional Challenges

- Accept query parameters or POST JSON
- Add custom domain and SSL cert
- Log to CloudWatch and monitor metrics

---

## 📚 References

- [Terraform Lambda Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)
- [AWS Lambda Guide](https://docs.aws.amazon.com/lambda/)
- [API Gateway Docs](https://docs.aws.amazon.com/apigateway/)

---

## ✅ Summary

You've now deployed a fully functional serverless HTTP endpoint using Terraform. This paves the way for microservices, automation bots, and lightweight web APIs in the cloud.