# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.api_lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.api_lambda.arn
}

output "api_gateway_id" {
  description = "ID of the created API Gateway"
  value       = aws_apigatewayv2_api.lambda_api.id
}

output "api_gateway_endpoint" {
  description = "Base URL of the API Gateway endpoint"
  value       = aws_apigatewayv2_stage.lambda_stage.invoke_url
}

output "api_hello_endpoint" {
  description = "URL of the hello API Gateway endpoint"
  value       = "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/hello"
}

output "api_info_endpoint" {
  description = "URL of the info API Gateway endpoint"
  value       = "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/info"
}

output "api_items_endpoint" {
  description = "URL of the items API Gateway endpoint"
  value       = "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/items"
}

output "cloudwatch_log_group" {
  description = "CloudWatch Log Group for the Lambda function"
  value       = "/aws/lambda/${aws_lambda_function.api_lambda.function_name}"
}

output "curl_test_commands" {
  description = "Example curl commands to test the API"
  value       = <<-EOT
    # Test GET /hello endpoint
    curl -X GET "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/hello"
    
    # Test GET /hello with query parameter
    curl -X GET "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/hello?name=YourName"
    
    # Test GET /info endpoint
    curl -X GET "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/info"
    
    # Test POST /items endpoint
    curl -X POST -H "Content-Type: application/json" \
      -d '{"name": "Test Item", "description": "This is a test item"}' \
      "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/items"
      
    # Test PUT /items endpoint
    curl -X PUT -H "Content-Type: application/json" \
      -d '{"name": "Updated Item", "status": "active"}' \
      "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/items/item-id-here"
      
    # Test DELETE /items endpoint
    curl -X DELETE "${aws_apigatewayv2_stage.lambda_stage.invoke_url}/items/item-id-here"
  EOT
}
