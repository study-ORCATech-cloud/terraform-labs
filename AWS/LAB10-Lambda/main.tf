provider "aws" {
  region = var.region
}

#############################################
# IAM Role for Lambda function
#############################################
# TODO: Create an IAM role for the Lambda function
# Requirements:
# - Name the role "${var.lambda_function_name}-role"
# - Use an assume role policy that allows the Lambda service to assume this role
# - Add appropriate tags from var.tags

# TODO: Attach the basic Lambda execution policy to the role
# Requirements:
# - Use the aws_iam_role_policy_attachment resource
# - Attach the AWS managed policy "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# - This policy allows Lambda to write logs to CloudWatch

#############################################
# Lambda function
#############################################
# TODO: Create an archive file for the Lambda function
# Requirements:
# - Use the "archive_file" data source
# - Package the code from the "lambda" directory
# - Output the zip file to "lambda_function.zip"

# TODO: Create the Lambda function
# Requirements:
# - Use the filename from the archive_file data source
# - Set the function name to var.lambda_function_name
# - Use the IAM role ARN from the role you created above
# - Set the handler to "main.handler"
# - Use the runtime from var.lambda_runtime
# - Set the source_code_hash to ensure updates when code changes
# - Configure memory_size from var.lambda_memory_size
# - Set the timeout from var.lambda_timeout
# - Add environment variables from var.lambda_environment_variables
# - Include tags from var.tags

#############################################
# API Gateway
#############################################
# TODO: Create an HTTP API Gateway
# Requirements:
# - Name it according to var.api_gateway_name
# - Use the "HTTP" protocol type
# - Configure CORS using the variables:
#   - var.cors_allow_origins for allowed origins
#   - var.cors_allow_methods for allowed methods
#   - var.cors_allow_headers for allowed headers
#   - var.cors_max_age for max age
# - Add tags from var.tags

# TODO: Create an API Gateway stage
# Requirements:
# - Link it to the API Gateway you created
# - Name it according to var.api_gateway_stage_name
# - Enable auto_deploy
# - Configure default route settings with throttling limits:
#   - burst limit from var.api_throttling_burst_limit
#   - rate limit from var.api_throttling_rate_limit
# - Add tags from var.tags

# TODO: Create an API Gateway integration
# Requirements:
# - Link it to the API Gateway you created
# - Use the "AWS_PROXY" integration type
# - Set the integration URI to the Lambda function's invoke ARN
# - Set the payload format version to "2.0"

# TODO: Create API Gateway routes for endpoints
# Requirements:
# - Create the following routes:
#   1. "GET /hello" route
#   2. "GET /info" route
#   3. "POST /items" route
#   4. "PUT /items/{itemId}" route
#   5. "DELETE /items/{itemId}" route
#   6. "OPTIONS /{proxy+}" route for CORS preflight
# - Link all routes to the integration you created

# TODO: Create a Lambda permission for API Gateway
# Requirements:
# - Use a statement ID of "AllowExecutionFromAPIGateway"
# - Allow the "lambda:InvokeFunction" action
# - Use the Lambda function name from your function
# - Set the principal to "apigateway.amazonaws.com"
# - Set the source ARN to limit which API Gateway can invoke the function
#   (use the API's execution ARN with "/*/*" for all stages and methods)
