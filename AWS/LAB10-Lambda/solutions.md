# LAB10: Serverless API with AWS Lambda and API Gateway Solutions

This document provides solutions for the Serverless API lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "aws" {
  region = var.aws_region
}

#############################################
# IAM Role for Lambda function
#############################################
resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#############################################
# Lambda function
#############################################
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "api_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.handler"
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout

  environment {
    variables = var.lambda_environment_variables
  }

  tags = var.tags
}

#############################################
# API Gateway
#############################################
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
    max_age       = var.cors_max_age
  }

  tags = var.tags
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = var.api_gateway_stage_name
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.api_throttling_burst_limit
    throttling_rate_limit  = var.api_throttling_rate_limit
  }

  tags = var.tags
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.lambda_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda_route_hello" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_info" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /info"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_post_items" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_put_items" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "PUT /items/{itemId}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_delete_items" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "DELETE /items/{itemId}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_options" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "OPTIONS /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Lambda permission to allow API Gateway to invoke Lambda for all routes
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}
```

## Step-by-Step Explanation

### 1. Create the IAM Role for Lambda Function

```terraform
resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}
```

This creates an IAM role that:
- Uses a dynamic name based on your Lambda function name
- Includes an assume role policy document that allows the Lambda service to assume this role
- Uses the `jsonencode` function to create the JSON policy document
- Applies the tags defined in `var.tags`

The assume role policy is a trust relationship that defines which entity can assume the role. In this case, it allows the Lambda service (`lambda.amazonaws.com`) to assume this role.

### 2. Attach the Lambda Basic Execution Policy

```terraform
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

This attaches the AWS managed policy `AWSLambdaBasicExecutionRole` to the role we created. The policy provides the minimum permissions that Lambda needs to write logs to CloudWatch, which is essential for monitoring and debugging your function.

The `aws_iam_role_policy_attachment` resource links an existing policy (identified by its ARN) to an IAM role. 

### 3. Create the Lambda Function Package

```terraform
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda_function.zip"
}
```

This creates a zip package from your Lambda function code:
- Uses the `archive_file` data source, which creates archives on the fly
- Specifies the archive type as "zip" (Lambda requires zip or jar files)
- Takes code from the "lambda" directory
- Outputs to "lambda_function.zip" in the module's directory
- The `${path.module}` expression refers to the directory where your module is defined

### 4. Create the Lambda Function

```terraform
resource "aws_lambda_function" "api_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.handler"
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  memory_size      = var.lambda_memory_size
  timeout          = var.lambda_timeout

  environment {
    variables = var.lambda_environment_variables
  }

  tags = var.tags
}
```

This creates the Lambda function with:
- The filename of the deployment package we created
- The function name from `var.lambda_function_name`
- The IAM role ARN from the role we created earlier
- The handler set to "main.handler", which refers to the `handler` function in `main.py` (or equivalent in other languages)
- The runtime specified in `var.lambda_runtime` (e.g., "python3.9")
- A source code hash that triggers updates when your function code changes
- Memory allocation and timeout values from variables
- Environment variables that your function can access
- Tags for organization

The `source_code_hash` parameter is important because it ensures that Terraform will update the function if your code changes. Without it, Terraform wouldn't detect code changes.

### 5. Create the API Gateway

```terraform
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = var.api_gateway_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = var.cors_allow_origins
    allow_methods = var.cors_allow_methods
    allow_headers = var.cors_allow_headers
    max_age       = var.cors_max_age
  }

  tags = var.tags
}
```

This creates an HTTP API Gateway:
- Named according to `var.api_gateway_name`
- Using the "HTTP" protocol type (more modern and cost-effective than the REST API type)
- With CORS (Cross-Origin Resource Sharing) configuration to control which websites can call your API
- The CORS configuration allows you to specify:
  - Which origins (websites) can call your API
  - Which HTTP methods are allowed
  - Which headers can be included in requests
  - How long browsers should cache the CORS settings
- Tags for organization

CORS is essential if you want to call your API from a web browser on a different domain than your API.

### 6. Create the API Gateway Stage

```terraform
resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = var.api_gateway_stage_name
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = var.api_throttling_burst_limit
    throttling_rate_limit  = var.api_throttling_rate_limit
  }

  tags = var.tags
}
```

This creates a deployment stage for your API:
- Links to the API Gateway we created
- Has a name like "prod" or "dev" from `var.api_gateway_stage_name`
- Enables automatic deployment when changes are made
- Configures throttling settings:
  - `throttling_burst_limit`: Maximum number of concurrent requests allowed
  - `throttling_rate_limit`: Number of requests per second
- Includes tags

API Gateway stages allow you to have multiple deployments of the same API, such as development, staging, and production environments.

### 7. Create the Lambda Integration

```terraform
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.lambda_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api_lambda.invoke_arn
  payload_format_version = "2.0"
}
```

This creates an integration between API Gateway and Lambda:
- Links to the API Gateway we created
- Uses the "AWS_PROXY" integration type, which passes the request almost directly to Lambda
- Sets the integration URI to the Lambda function's invoke ARN
- Uses payload format version "2.0" (which has a more streamlined request/response format)

The AWS_PROXY integration type simplifies the integration by automatically mapping the HTTP request to the Lambda event and the Lambda response to an HTTP response.

### 8. Create API Gateway Routes

The following resources create the routes that define the API endpoints:

```terraform
resource "aws_apigatewayv2_route" "lambda_route_hello" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_info" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /info"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_post_items" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "POST /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_put_items" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "PUT /items/{itemId}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_delete_items" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "DELETE /items/{itemId}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_route_options" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "OPTIONS /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
```

Each route:
- Links to the API Gateway we created
- Defines a route key in the format "HTTP_METHOD /path"
- Points to the Lambda integration we created

The routes include:
- GET /hello: A simple endpoint that returns a greeting
- GET /info: An endpoint that returns information about the service
- POST /items: Endpoint to create a new item
- PUT /items/{itemId}: Endpoint to update an existing item by ID
- DELETE /items/{itemId}: Endpoint to delete an item by ID
- OPTIONS /{proxy+}: A special route that handles CORS preflight requests for any path

Note that `{itemId}` is a path parameter that will be available in the Lambda event, and `{proxy+}` is a greedy path parameter that matches any path.

### 9. Configure Lambda Permission for API Gateway

```terraform
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}
```

This creates a resource policy on the Lambda function that allows API Gateway to invoke it:
- Uses a descriptive statement ID
- Allows the "lambda:InvokeFunction" action
- Applies to our Lambda function
- Allows the API Gateway service principal to invoke the function
- Restricts the permission to our specific API Gateway using the source ARN
- The `/*/*` at the end allows any stage and any method to invoke the function

This permission is essential. Without it, API Gateway would receive a "permission denied" error when trying to invoke your Lambda function, even though the integration is set up correctly.

## Testing the Solution

After applying the Terraform configuration, you can test your API in several ways:

1. **Use the AWS Console**:
   - Navigate to API Gateway in the AWS Console
   - Select your API
   - Use the "Test" tab to send requests to different endpoints

2. **Use curl**:
   ```bash
   # Test the hello endpoint
   curl -X GET "$(terraform output -raw api_gateway_endpoint)/hello"
   
   # Test with a query parameter
   curl -X GET "$(terraform output -raw api_gateway_endpoint)/hello?name=YourName"
   
   # Create an item
   curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"name": "New Item", "description": "Test item"}' \
     "$(terraform output -raw api_gateway_endpoint)/items"
   ```

3. **Use a browser**: 
   - Open the hello endpoint URL (from terraform output) in a browser
   - This will execute a GET request to the /hello endpoint

4. **Check CloudWatch Logs**:
   - Go to CloudWatch Logs in the AWS Console
   - Find the log group for your Lambda function (/aws/lambda/your-function-name)
   - View the log streams to see the function's output and any errors

## Common Troubleshooting Tips

1. **CORS Issues**: If you're calling your API from a web browser and getting CORS errors:
   - Check that your `cors_allow_origins` includes the origin of your web page
   - Ensure your `cors_allow_methods` includes the HTTP method you're using
   - Make sure your `cors_allow_headers` includes any custom headers you're sending

2. **Lambda Invocation Errors**: If API Gateway can't invoke your Lambda function:
   - Verify that the Lambda permission is configured correctly
   - Check that the function name and API Gateway ARN are correct

3. **Code Issues**: If your Lambda function returns errors:
   - Check CloudWatch Logs for detailed error messages
   - Test your function directly in the Lambda console

4. **API Gateway Issues**: If your API isn't responding as expected:
   - Verify the route configurations
   - Check that the integration is set up correctly
   - Make sure the deployment stage is created properly

5. **Package Issues**: If your Lambda function isn't being packaged correctly:
   - Manually inspect the contents of the zip file
   - Make sure all dependencies are included (for languages that require external packages)

## Additional Resources

- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
- [API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
- [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/) - An alternative to consider for serverless applications
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) 