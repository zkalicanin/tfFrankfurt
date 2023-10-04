# API Gateway outputs
output "api_gateway_id" {
  description = "ID of the created API Gateway"
  value       = aws_api_gateway_rest_api.my_api.id
}

output "api_gateway_url" {
  description = "URL of the created API Gateway"
  value       = aws_api_gateway_stage.dev_stage.invoke_url
}

output "api_key" {
  description = "API Key for the created API Gateway"
  value       = aws_api_gateway_api_key.my_api_key.value
}

output "execution_role_arn" {
  description = "ARN of the IAM role associated with the API Gateway execution"
  value       = aws_iam_role.api_gateway_execution_role.arn
}

output "rest_api_id" {
  description = "ID of the created API Gateway REST API"
  value       = aws_api_gateway_rest_api.my_api.id
}

output "resource_id" {
  description = "ID of the API Gateway resource"
  value       = aws_api_gateway_resource.resource.id
}


output "http_method" {
  description = "HTTP method used in the API Gateway"
  value       = aws_api_gateway_method.method.http_method
}


