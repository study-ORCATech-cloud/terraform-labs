# LAB10: Serverless API with AWS Lambda and API Gateway using Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Terraform** to build a complete serverless API by integrating **AWS Lambda** with **Amazon API Gateway**. This architecture enables you to run code without provisioning or managing servers, automatically scales with traffic, and only charges for actual compute time consumed. You'll configure IAM permissions, set up API endpoints, implement request/response handling, and create a production-ready deployment.

---

## 🎯 Learning Objectives

- Create a serverless Lambda function with proper IAM execution roles
- Configure API Gateway HTTP API with routes and integrations
- Implement various HTTP methods (GET, POST, PUT, DELETE)
- Set up CORS for cross-origin access
- Deploy the API to a stage with proper logging and monitoring
- Implement error handling and proper HTTP response codes
- Test the API endpoints with curl commands

---

## 🧰 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.3+ installed locally
- AWS CLI configured with valid credentials
- Basic understanding of REST APIs and HTTP methods
- Knowledge of Python (for understanding the Lambda function code)

---

## 📁 Files Structure

```
AWS/LAB10-Lambda/
├── main.tf                  # Lambda, IAM, API Gateway resources with TODOs
├── variables.tf             # Variable definitions for customization
├── outputs.tf               # Output definitions with TODOs
├── providers.tf             # AWS provider configuration
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
├── lambda/                  # Lambda function source code
│   └── main.py              # Python handler implementing the API endpoints
├── solutions.md             # Solutions to the TODOs (for reference)
└── README.md                # This documentation file
```

---

## 🌐 Serverless API Architecture

This lab implements a serverless API with the following components:

1. **API Gateway HTTP API**: Handles HTTP requests from clients
2. **Lambda Function**: Processes API requests and returns responses
3. **IAM Role & Policies**: Grants Lambda necessary permissions
4. **CloudWatch Logs**: Captures Lambda execution logs
5. **CORS Configuration**: Enables cross-origin resource sharing

These components work together to create a fully serverless solution without managing any servers.

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB10-Lambda
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure Lambda and API Gateway Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Customize the configuration in `terraform.tfvars` to adjust:
   - Lambda function name, memory, and timeout
   - API Gateway name and throttling settings
   - CORS configuration for cross-origin access
   - Environment variables for Lambda
   - Resource tags

### Step 4: Complete the TODO Sections

This lab contains several TODO sections in main.tf and outputs.tf that you need to complete:

1. In `main.tf`:

   a. **IAM Role Configuration**
      - Create an IAM role for the Lambda function
      - Configure assume role policy for Lambda
      - Attach the basic execution policy

   b. **Lambda Function Setup**
      - Create an archive of the Lambda function code
      - Create the Lambda function with appropriate settings
      - Configure memory, timeout, and environment variables

   c. **API Gateway Configuration**
      - Create an HTTP API Gateway
      - Configure CORS settings
      - Set up an API stage with deployment options
      - Configure throttling limits

   d. **Integrations and Routes**
      - Create a Lambda integration for the API Gateway
      - Define routes for different HTTP methods
      - Set up permissions for API Gateway to invoke Lambda

2. In `outputs.tf`:
   - Define outputs for Lambda function information
   - Create outputs for API Gateway endpoints
   - Set up example curl commands for testing

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the resources to be created:
   - IAM role and policy attachments
   - Lambda function with your configuration
   - API Gateway with routes and integrations
   - Lambda permissions for API Gateway

### Step 6: Apply the Configuration

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, Terraform will display outputs including:
   - Lambda function name and ARN
   - API Gateway endpoint URLs
   - Example curl commands for testing

### Step 7: Test the API Endpoints

1. Test the `/hello` endpoint:
   ```bash
   # Use the command from the curl_test_commands output
   curl -X GET "$(terraform output -raw api_hello_endpoint)"
   
   # With a query parameter
   curl -X GET "$(terraform output -raw api_hello_endpoint)?name=YourName"
   ```

2. Test the `/info` endpoint:
   ```bash
   curl -X GET "$(terraform output -raw api_info_endpoint)"
   ```

3. Test the `/items` endpoints:
   ```bash
   # Create an item (POST)
   curl -X POST -H "Content-Type: application/json" \
     -d '{"name": "Test Item", "description": "A test item"}' \
     "$(terraform output -raw api_items_endpoint)"
   
   # Update an item (PUT) - Replace "item-id" with an actual ID from a previous POST
   curl -X PUT -H "Content-Type: application/json" \
     -d '{"name": "Updated Item", "status": "active"}' \
     "$(terraform output -raw api_items_endpoint)/item-id"
   
   # Delete an item (DELETE) - Replace "item-id" with an actual ID
   curl -X DELETE "$(terraform output -raw api_items_endpoint)/item-id"
   ```

### Step 8: View CloudWatch Logs

1. Check the Lambda function logs in CloudWatch:
   ```bash
   aws logs tail "$(terraform output -raw cloudwatch_log_group)" --follow
   ```

2. Or navigate to the CloudWatch Logs console:
   - Go to AWS CloudWatch console
   - Navigate to Log Groups
   - Find the log group for your Lambda function
   - Examine the log streams for detailed execution information

---

## 🔍 Understanding Serverless Architecture

### Serverless Request Flow Diagram

```
                                                 +------------------+
                                                 |                  |
                                                 |   AWS Account    |
                                                 |                  |
          +------------+        Request          +------------------+
          |            | -----------------------> |                  |
          |   Client   |                          |  API Gateway    |
          |            | <----------------------- |  (HTTP API)     |
          +------------+        Response          |                  |
              ^                                   +--------+----+---+
              |                                            |
              |                                            |
              |                                            | Invoke
              |                                            v
              |                                   +--------+--------+
              |                                   |                 |
              |                                   | Lambda Function |
              |                                   |                 |
              |                                   |  +-------------+|
              |                                   |  |             ||
   API Endpoints:                                 |  |  main.py    ||
   - GET /hello                                   |  |  def handler ||
   - GET /info                                    |  |   ...       ||
   - POST /items                                  |  +-------------+|
   - PUT /items/{itemId}                          |                 |
   - DELETE /items/{itemId}                       +-+------+--------+
                                                    |      |
                                                    |      |
                                                    |      | Permissions
                                                    v      v
                                                  +-+------+--------+
                                                  |                 |
                                                  |    IAM Role     |
                                                  |                 |
                                                  +---------+-------+
                                                            |
                                                            | Write logs
                                                            v
                                                  +---------+-------+
                                                  |                 |
                                                  |   CloudWatch    |
                                                  |     Logs        |
                                                  |                 |
                                                  +-----------------+
```

### Key Components Explained

1. **Lambda Function**: The serverless compute service that processes requests
   ```hcl
   resource "aws_lambda_function" "api_lambda" {
     function_name = var.lambda_function_name
     role          = aws_iam_role.lambda_role.arn
     handler       = "main.handler"
     runtime       = var.lambda_runtime
     timeout       = var.lambda_timeout
     memory_size   = var.lambda_memory_size
     # Additional settings...
   }
   ```

2. **IAM Role**: Provides permissions for Lambda to access AWS services
   ```hcl
   resource "aws_iam_role" "lambda_role" {
     name = "${var.lambda_function_name}-role"
     assume_role_policy = jsonencode({
       Version = "2012-10-17"
       Statement = [{
         Action = "sts:AssumeRole"
         Effect = "Allow"
         Principal = {
           Service = "lambda.amazonaws.com"
         }
       }]
     })
     # Tags...
   }
   ```

3. **API Gateway HTTP API**: Creates a RESTful API that invokes Lambda
   ```hcl
   resource "aws_apigatewayv2_api" "lambda_api" {
     name          = var.api_gateway_name
     protocol_type = "HTTP"
     cors_configuration {
       allow_origins = var.cors_allow_origins
       allow_methods = var.cors_allow_methods
       allow_headers = var.cors_allow_headers
       max_age       = var.cors_max_age
     }
     # Tags...
   }
   ```

4. **API Gateway Integration**: Links API Gateway to Lambda
   ```hcl
   resource "aws_apigatewayv2_integration" "lambda_integration" {
     api_id             = aws_apigatewayv2_api.lambda_api.id
     integration_type   = "AWS_PROXY"
     integration_uri    = aws_lambda_function.api_lambda.invoke_arn
     integration_method = "POST"
     payload_format_version = "2.0"
   }
   ```

5. **Lambda Permission**: Allows API Gateway to invoke Lambda
   ```hcl
   resource "aws_lambda_permission" "api_gateway_permission" {
     statement_id  = "AllowExecutionFromAPIGateway"
     action        = "lambda:InvokeFunction"
     function_name = aws_lambda_function.api_lambda.function_name
     principal     = "apigateway.amazonaws.com"
     source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
   }
   ```

---

## 💡 Key Learning Points

1. **Serverless Computing Principles**:
   - Running code without managing servers
   - Pay-per-use billing model (only charged for execution time)
   - Automatic scaling to handle variable workloads
   - Built-in high availability and fault tolerance
   - Event-driven architecture with various triggers

2. **API Development Concepts**:
   - RESTful API design and implementation
   - HTTP methods (GET, POST, PUT, DELETE) for different operations
   - Request/response handling and status codes
   - Path and query parameters for data retrieval
   - Request body parsing for data submission

3. **Terraform Techniques**:
   - Managing serverless resources with infrastructure as code
   - Configuring IAM permissions with least privilege
   - Using data sources for file processing
   - Setting up integrations between AWS services
   - Managing environment variables and configuration

4. **Security Best Practices**:
   - Using IAM roles with least privilege
   - Implementing CORS for secure cross-origin access
   - Configuring throttling to prevent abuse
   - Proper error handling to avoid information leakage
   - Setting timeouts and memory limits appropriately

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Add API Key Authentication**:
   Implement API key authentication for your endpoints
   ```hcl
   resource "aws_apigatewayv2_api_key" "api_key" {
     name = "my-api-key"
   }
   
   resource "aws_apigatewayv2_usage_plan" "usage_plan" {
     name = "standard-plan"
     api_stages {
       api_id = aws_apigatewayv2_api.lambda_api.id
       stage  = aws_apigatewayv2_stage.lambda_stage.name
     }
   }
   
   resource "aws_apigatewayv2_usage_plan_key" "usage_plan_key" {
     key_id        = aws_apigatewayv2_api_key.api_key.id
     key_type      = "API_KEY"
     usage_plan_id = aws_apigatewayv2_usage_plan.usage_plan.id
   }
   ```

2. **Add DynamoDB Integration**:
   Connect your Lambda function to a DynamoDB table for persistent storage
   ```hcl
   resource "aws_dynamodb_table" "items_table" {
     name           = "items"
     billing_mode   = "PAY_PER_REQUEST"
     hash_key       = "id"
     
     attribute {
       name = "id"
       type = "S"
     }
   }
   ```

3. **Implement Custom Domain Name**:
   Add a custom domain with an SSL certificate
   ```hcl
   resource "aws_apigatewayv2_domain_name" "custom_domain" {
     domain_name = "api.example.com"
     
     domain_name_configuration {
       certificate_arn = aws_acm_certificate.api_cert.arn
       endpoint_type   = "REGIONAL"
       security_policy = "TLS_1_2"
     }
   }
   ```

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. Remove all resources with Terraform:
   ```bash
   terraform destroy
   ```

2. Type `yes` when prompted to confirm.

3. Verify that all resources have been deleted:
   ```bash
   # Check if Lambda function exists
   aws lambda get-function --function-name $(terraform output -raw lambda_function_name) 2>&1 || echo "Lambda function has been deleted"
   
   # Check if API Gateway exists
   aws apigatewayv2 get-api --api-id $(terraform output -raw api_gateway_id) 2>&1 || echo "API Gateway has been deleted"
   
   # Check if CloudWatch Log Group exists
   aws logs describe-log-groups --log-group-name-prefix $(terraform output -raw cloudwatch_log_group) --query 'logGroups[*].logGroupName' --output text | grep -q "^$(terraform output -raw cloudwatch_log_group)$" || echo "Log group has been deleted"
   ```

4. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars lambda_function.zip
   ```

> ⚠️ **Important Note**: Even though Lambda functions and API Gateway only charge for usage, it's still good practice to clean up resources to avoid any unexpected charges and keep your AWS account clean.

---

## 🚫 Common Errors and Troubleshooting

1. **Lambda Execution Role Issues**:
   ```
   Error: Error creating Lambda function: InvalidParameterValueException: The role defined for the function cannot be assumed by Lambda.
   ```
   **Solution**: Ensure the Lambda execution role has the correct trust relationship with Lambda service.

2. **Lambda Deployment Package Too Large**:
   ```
   Error: Error creating Lambda function: InvalidParameterValueException: Unzipped size must be smaller than...
   ```
   **Solution**: Reduce package size by removing unnecessary dependencies or files.

3. **API Gateway Integration Issues**:
   ```
   Error: Error creating API Gateway v2 integration: BadRequestException: Integrations must be invocable
   ```
   **Solution**: Make sure the Lambda ARN is correct and the permission to invoke Lambda is set up properly.

4. **CORS Configuration Problems**:
   ```
   Access to XMLHttpRequest at 'your-api-url' from origin 'http://localhost:3000' has been blocked by CORS policy
   ```
   **Solution**: Check that CORS is properly configured in the API Gateway and that your origins, methods, and headers are correctly specified.

5. **Lambda Permission Issues**:
   ```
   Error: Lambda was not able to write to CloudWatch Logs
   ```
   **Solution**: Ensure the Lambda execution role has the AWSLambdaBasicExecutionRole policy attached.

6. **API Gateway Stage Deployment Issues**:
   ```
   Error: Not Found status code when accessing the API endpoint
   ```
   **Solution**: Verify the API Gateway stage is properly deployed and auto_deploy is set to true.

---

## 📚 Additional Resources

- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [Amazon API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/)
- [Serverless Framework](https://www.serverless.com/)
- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [API Gateway REST API vs HTTP API](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-vs-rest.html)

---

## 🚀 Next Lab

Proceed to [LAB11-CloudFront-CDN](../LAB11-CloudFront-CDN/) to learn how to set up a content delivery network (CDN) for optimizing content delivery globally using Amazon CloudFront.

---

Happy Terraforming!