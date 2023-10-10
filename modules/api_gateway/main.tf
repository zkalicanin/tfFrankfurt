
# API Gateway Rest API
resource "aws_api_gateway_rest_api" "my_api" {
  name        = var.api_name
  description = var.api_description
}
# 
resource "aws_api_gateway_vpc_link" "vpc_link" {
  name = "frankfurt_2_vpc_link"
  description = "VPC Link for Frankfurt 2"
  target_arns = [aws_api_gateway_rest_api.my_api.execution_arn]
}
# API Gateway Resource
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = var.path_part
}

# API Gateway Method
resource "aws_api_gateway_method" "method" {
    rest_api_id = aws_api_gateway_rest_api.my_api.id
    resource_id = aws_api_gateway_resource.resource.id
    http_method = "POST"
    authorization = "NONE"  
}

# API Gateway API Key
resource "aws_api_gateway_api_key" "my_api_key" {
  name        = "my_api_key"
  description = "This is my API key for demonstration purposes"
  enabled     = true

  tags = {
    Environment = "Dev"
    Project     = "Demo"
  }
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = var.stage_name
}

# API Gateway Stage
resource "aws_api_gateway_stage" "dev_stage" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  stage_name    = var.stage_name
  deployment_id = aws_api_gateway_deployment.deployment.id
}

# API Gateway Integration
resource "aws_api_gateway_usage_plan" "my_usage_plan" {
  name        = "my-usage-plan"
  description = "This is my usage plan for demonstration purposes"
  product_code = "my-product-code"
  quota_settings {
    limit  = 10000
    offset = 0
    period = "MONTH"
  }
  api_stages {
    api_id = aws_api_gateway_rest_api.my_api.id
    stage  = var.stage_name
  }
}

# API Gateway Usage Plan Key Assiciation
resource "aws_api_gateway_usage_plan_key" "my_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.my_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.my_usage_plan.id
}

# Define an IAM policy for API Gateway logging
resource "aws_iam_policy" "api_gateway_cloudwatch_logs_policy" {
  name        = "APIGatewayCloudWatchLogsPolicy"
  description = "IAM policy to allow API Gateway to create and write logs to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

# Create an IAM Role for API Gateway Execution
resource "aws_iam_role" "api_gateway_execution_role" {
  name = "api-gateway-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the IAM policy to the IAM role associated with your API Gateway stage
resource "aws_iam_role_policy_attachment" "api_gateway_role_policy_attachment" {
  policy_arn = aws_iam_policy.api_gateway_cloudwatch_logs_policy.arn
  role       = aws_iam_role.api_gateway_execution_role.name
}


