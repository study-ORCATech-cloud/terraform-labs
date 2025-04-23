# LAB10: Serverless API with AWS Lambda and API Gateway using Terraform

## 📝 Lab Overview

In this comprehensive lab, you'll use **Terraform** to build a complete serverless API by integrating **AWS Lambda** with **Amazon API Gateway**. This architecture enables you to run code without provisioning or managing servers, automatically scales with traffic, and only charges for actual compute time consumed. You'll configure IAM permissions, set up API endpoints, implement request/response handling, and create a production-ready deployment.

---

## 🎯 Objectives

- Create a serverless Lambda function with proper IAM execution roles
- Configure API Gateway REST API with resources, methods, and integrations
- Set up request/response mapping and validation
- Deploy the API to a stage with proper logging and monitoring
- Implement error handling and proper HTTP response codes
- Test the API endpoint using various HTTP methods

---

## 🧰 Prerequisites

- AWS account with appropriate permissions
- Terraform v1.3+ installed locally
- AWS CLI configured with valid credentials
- Basic understanding of REST APIs and HTTP methods
- `zip` utility installed for packaging Lambda functions
- Code editor for working with function source code

---

## 📁 File Structure

```bash
AWS/LAB10-Lambda/
├── main.tf               # Lambda, IAM, API Gateway configuration
├── variables.tf          # Variable definitions for customization
├── outputs.tf            # Output values (API URL, function ARN)
├── terraform.tfvars      # Variable values configuration
├── lambda/               # Lambda function source code
│   ├── index.js          # Sample Node.js function handler
│   └── main.py           # Sample Python function handler
└── README.md             # This documentation file
```

---

## 🔄 AWS Services Used

| Service | Purpose in this Lab |
|---------|---------------------|
| **AWS Lambda** | Serverless compute service that runs your code in response to events |
| **API Gateway** | Fully managed service to create, publish, and secure APIs |
| **IAM** | Identity and Access Management for Lambda execution roles |
| **CloudWatch Logs** | Automatic logging of Lambda function execution |
| **CloudWatch Metrics** | Performance monitoring for Lambda and API Gateway |

---

## 🚀 Steps to Complete the Lab

### 1. Prepare the Lambda Function

1. **Choose a runtime**
   - This lab provides examples for Node.js and Python
   - Select one based on your preference by updating `terraform.tfvars`

2. **Review the function code**
   - Examine the handler code in the `lambda/` directory
   - The code implements a simple API that handles different HTTP methods

3. **Package the function**
   ```bash
   # For Python
   cd lambda && zip ../function.zip main.py && cd ..
   ```

### 2. Deploy the Infrastructure

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review the deployment plan**
   ```bash
   terraform plan
   ```

3. **Apply the configuration**
   ```bash
   terraform apply
   ```

4. **Note the outputs**
   - API URL for testing
   - Function ARN for reference
   - CloudWatch log group for monitoring

### 3. Test the API Endpoint

1. **Test with curl**
   ```bash
   # GET request
   curl $(terraform output -raw api_url)
   
   # POST request with data
   curl -X POST -H "Content-Type: application/json" \
     -d '{"message":"Hello Serverless"}' \
     $(terraform output -raw api_url)
   ```

2. **Test in browser**
   - Open the API URL in a web browser for GET requests
   - Observe the response

3. **Monitor CloudWatch logs**
   ```bash
   aws logs get-log-events \
     --log-group-name "/aws/lambda/$(terraform output -raw function_name)" \
     --log-stream-name=$(aws logs describe-log-streams \
       --log-group-name "/aws/lambda/$(terraform output -raw function_name)" \
       --query "logStreams[0].logStreamName" \
       --output text)
   ```

---

## 🔧 Understanding the Architecture

### Lambda Function

The Lambda function serves as the backend logic for your API. When deployed:

1. The function runs in an isolated environment (execution context)
2. It receives an event object containing request details
3. It processes the request and returns a response
4. AWS automatically handles scaling based on incoming requests

### API Gateway

API Gateway creates a RESTful API that:

1. Accepts HTTP requests from clients
2. Transforms and validates those requests
3. Passes them to the Lambda function
4. Returns the function's response to the client
5. Handles authentication, throttling, and caching

### CORS Configuration

The API Gateway is configured with Cross-Origin Resource Sharing (CORS) settings that:

1. Define which origins can access your API
2. Specify allowed HTTP methods
3. Set allowed headers for the requests
4. Configure caching duration for preflight requests

These settings are fully customizable via the following variables:
- `cors_allow_origins` - List of allowed origins (e.g., `["*"]` for all origins)
- `cors_allow_methods` - List of allowed HTTP methods
- `cors_allow_headers` - List of allowed HTTP headers
- `cors_max_age` - Duration in seconds for browsers to cache preflight responses

### IAM Role

The created IAM role:

1. Provides Lambda with permissions to execute
2. Enables logging to CloudWatch
3. Enforces the principle of least privilege

### Environment Variables

The Lambda function has access to environment variables that control its behavior:

1. **environment** - Identifies the deployment environment (e.g., "production", "dev")
2. **LOG_LEVEL** - Controls the verbosity of logging (e.g., "debug", "info")

---

## 📈 Monitoring and Logging

Your serverless API automatically includes:

1. **CloudWatch Logs**
   - All Lambda function output and errors
   - API Gateway access logs (if enabled)

2. **CloudWatch Metrics**
   - Invocation count and duration
   - Error rates and throttling
   - API latency and request counts

Access logs in CloudWatch by navigating to the log group or using the AWS CLI:

```bash
aws logs tail "/aws/lambda/$(terraform output -raw function_name)" --follow
```

---

## 🧼 Cleanup

To avoid incurring unnecessary charges, clean up all resources when finished:

```bash
terraform destroy
```

This will remove:
- Lambda function and associated IAM role
- API Gateway REST API and deployment
- CloudWatch Log groups

**Note**: Cleanup is immediate, but some CloudWatch Logs may persist for a retention period.

---

## 💡 Key Concepts

### Serverless Computing Model

- **No Server Management**: AWS handles all infrastructure
- **Auto-scaling**: Capacity scales automatically with demand
- **Pay-per-use**: Charged only for compute time used
- **Event-driven**: Functions execute in response to events

### API Gateway Components

- **Resources**: URL paths in your API
- **Methods**: HTTP verbs (GET, POST, etc.)
- **Integrations**: Connections to backend services
- **Stages**: Deployments of your API (dev, prod, etc.)
- **API Keys**: For client authentication and quota management

### Lambda Concepts

- **Handler**: Function entry point
- **Event**: Input data structure
- **Context**: Runtime information object
- **Cold Start**: Initial initialization delay
- **Execution Environment**: Isolated runtime container

---

## 🔧 Customizing the Deployment

This Terraform configuration is designed to be highly customizable through variables. You can tailor the deployment to your specific needs by adjusting the values in `terraform.tfvars`:

### Lambda Configuration

- `lambda_function_name` - Name of your Lambda function
- `lambda_memory_size` - Memory allocation in MB (128MB to 10,240MB)
- `lambda_timeout` - Maximum execution time in seconds (up to 900s)
- `lambda_runtime` - Runtime environment (e.g., "nodejs18.x", "python3.9")
- `lambda_environment_variables` - Environment variables passed to the function

### API Gateway Configuration

- `api_gateway_name` - Name of your API Gateway
- `api_gateway_stage_name` - Deployment stage name (e.g., "prod", "dev", "test")
- `api_throttling_burst_limit` - Maximum API request burst size
- `api_throttling_rate_limit` - Steady-state requests per second

### CORS Configuration

- `cors_allow_origins` - List of allowed origins
- `cors_allow_methods` - List of allowed HTTP methods
- `cors_allow_headers` - List of allowed HTTP headers
- `cors_max_age` - Duration in seconds for preflight caching

### Example Configuration

```hcl
# terraform.tfvars
region                   = "eu-west-1"
lambda_function_name     = "api-handler"
lambda_memory_size       = 256
lambda_timeout           = 30
lambda_runtime           = "python3.9"
api_gateway_name         = "api-gateway"
api_gateway_stage_name   = "prod"
api_throttling_burst_limit = 10
api_throttling_rate_limit  = 5

lambda_environment_variables = {
  environment = "production"
  LOG_LEVEL   = "info"
}

cors_allow_origins = ["*"]
cors_allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
cors_allow_headers = ["Content-Type", "Authorization", "X-Api-Key"]
cors_max_age       = 300

tags = {
  Environment = "production"
  Project     = "ServerlessAPI"
  Terraform   = "true"
  Owner       = "DevOps"
}
```

---

## 🧪 Advanced Extensions

Take your serverless knowledge further with these challenges:

1. **Add Authentication**
   - Implement API key authentication in API Gateway
   - Configure AWS Cognito user pools for OAuth2

2. **Enhance Request Handling**
   - Add request validation with JSON Schema
   - Create response models for structured data

3. **Optimize Performance**
   - Configure Lambda provisioned concurrency
   - Implement API Gateway caching

4. **Implement Custom Domain**
   - Register a domain in Route 53
   - Configure custom domain name for API Gateway
   - Set up TLS certificate with AWS Certificate Manager

5. **Advanced Logging**
   - Enable API Gateway access logging
   - Implement structured logging in Lambda function
   - Create CloudWatch dashboards and alarms

---

## 📚 References

- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Serverless Best Practices](https://docs.aws.amazon.com/lambda/latest/operatorguide/serverless-bp.html)
- [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/)
- [API Gateway Mapping Template Reference](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-mapping-template-reference.html)

---

## ✅ Key Takeaways

After completing this lab, you'll understand how to:

- Build serverless applications using infrastructure as code
- Configure secure API endpoints with proper authentication
- Manage infrastructure and application code together
- Implement a cost-effective, scalable application architecture
- Monitor and troubleshoot serverless applications
- Apply best practices for serverless development

This serverless architecture pattern forms the foundation for modern cloud-native applications, enabling rapid development and deployment without managing traditional server infrastructure.