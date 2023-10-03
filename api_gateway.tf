module "api_gateway" {
  source          = "./modules/api_gateway"
  api_name        = "my-api"
  api_description = "This is my API for demonstration purposes"
  stage_name      = "dev"
  path_part       = "myresource"

  # API Gateway Method
  # API Gateway Stage
  # API Gateway API Key
  # API Gateway Integration
  # API Gateway Usage Plan
  usage_plan_name = "my-usage-plan"
  usage_plan_product_code = "my-product-code"
}
