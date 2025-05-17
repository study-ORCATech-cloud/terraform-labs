# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

# TODO: Define an output for lambda_function_name
# Requirements:
# - Name it "lambda_function_name"
# - Description should be "Name of the Lambda function"
# - Value should be the function_name of the Lambda function you created
# HINT: Use aws_lambda_function.api_lambda.function_name

# TODO: Define an output for lambda_function_arn
# Requirements:
# - Name it "lambda_function_arn"
# - Description should be "ARN of the Lambda function"
# - Value should be the ARN of the Lambda function you created
# HINT: Use aws_lambda_function.api_lambda.arn

# TODO: Define an output for api_gateway_id
# Requirements:
# - Name it "api_gateway_id"
# - Description should be "ID of the created API Gateway"
# - Value should be the ID of the API Gateway you created
# HINT: Use aws_apigatewayv2_api.lambda_api.id

# TODO: Define an output for api_gateway_endpoint
# Requirements:
# - Name it "api_gateway_endpoint"
# - Description should be "Base URL of the API Gateway endpoint"
# - Value should be the invoke_url of the API Gateway stage
# HINT: Use aws_apigatewayv2_stage.lambda_stage.invoke_url

# TODO: Define an output for api_hello_endpoint
# Requirements:
# - Name it "api_hello_endpoint"
# - Description should be "URL of the hello API Gateway endpoint"
# - Value should be the invoke_url of the API Gateway stage followed by "/hello"
# HINT: Use "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/hello"

# TODO: Define an output for api_info_endpoint
# Requirements:
# - Name it "api_info_endpoint"
# - Description should be "URL of the info API Gateway endpoint"
# - Value should be the invoke_url of the API Gateway stage followed by "/info"
# HINT: Use "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/info"

# TODO: Define an output for api_items_endpoint
# Requirements:
# - Name it "api_items_endpoint"
# - Description should be "URL of the items API Gateway endpoint"
# - Value should be the invoke_url of the API Gateway stage followed by "/items"
# HINT: Use "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/items"

# TODO: Define an output for cloudwatch_log_group
# Requirements:
# - Name it "cloudwatch_log_group"
# - Description should be "CloudWatch Log Group for the Lambda function"
# - Value should be the CloudWatch log group path for the Lambda function
# HINT: Use "/aws/lambda/${aws_lambda_function.api_lambda.function_name}"

# TODO: Define an output for curl_test_commands
# Requirements:
# - Name it "curl_test_commands"
# - Description should be "Example curl commands to test the API"
# - Value should be a multi-line string with example curl commands for testing each endpoint
# HINT: Use a heredoc string with curl commands for GET, POST, PUT, and DELETE methods
