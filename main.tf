locals {
  # Provider
  region                  = "eu-central-1"
  access_key              = "*"
  secret_key              = "*"

  # VPC
  vpc_name                = "frankfurt_2_vpc"
  vpc_cidr                = "172.31.0.0/16"
  public_subnet_cidrs     = ["172.31.0.0/20", "172.31.16.0/20"]
  private_subnet_cidrs    = ["172.31.32.0/20", "172.31.48.0/20"]
  internet_gateway_name   = "frankfurt_2_igw"
  route_table_name        = "frankfurt_2_rt"
  route_cidr_block        = "172.31.0.0/19"

  # API Gateway
  api_name                = "my-api"
  api_description         = "This is my API for demonstration purposes"
  stage_name              = "dev"
  path_part               = "myresource"
  usage_plan_name         = "my-usage-plan"
  usage_plan_product_code = "my-product-code"

  # SQS
  sqs_queue_name          = "my_queue"
  sqs_dlq_name            = "my_queue_dlq"

  # Lambda
  lambda_filename         = "lambda.zip"
  lambda_function_name    = "lambda-function"
  lambda_handler          = "lambda_function.lambda_handler"
  lambda_runtime          = "dotnetcore3.1"

  # RDS
  rds_name                = "mydb"
  rds_username            = "admin"
  rds_password            = "admin123"
  rds_engine              = "sqlserver-ex"
  rds_engine_version      = "15.00.2000.05.v1"
  rds_instance_class      = "db.t2.micro"
  rds_allocated_storage   = 20
  rds_parameter_group     = "default.sqlserver-ex-15.00"
  rds_backup_retention    = 7
  rds_skip_final_snapshot = true
  rds_monitoring_interval = 60
  
}


provider "aws" {
  
  region                  = local.region
  access_key              = local.access_key
  secret_key              = local.secret_key
}

module "vpc" {
  source                  = "./modules/vpc"

  # Input variables for VPC module
  region                  = local.region
  vpc_name                = local.vpc_name
  vpc_cidr                = local.vpc_cidr
  public_subnet_cidrs     = local.public_subnet_cidrs
  private_subnet_cidrs    = local.private_subnet_cidrs
  internet_gateway_name   = local.internet_gateway_name
  route_table_name        = local.route_table_name
  route_cidr_block        = local.route_cidr_block
}

module "api_gateway" {
  source                  = "./modules/api_gateway"
  # Input variables for API Gateway module
  vpc_id                  = module.vpc.vpc_id
  api_name                = local.api_name
  api_description         = local.api_description
  stage_name              = local.stage_name
  path_part               = local.path_part
  usage_plan_name         = local.usage_plan_name
  usage_plan_product_code = local.usage_plan_product_code
}

module "sqs_queues" {
  source                  = "./modules/sqs"
  # Input variables for SQS module
  queue_name              = local.sqs_queue_name
  sqs_dlq_name            = local.sqs_dlq_name
  subnet_ids              = [ module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1] ]
  api_gateway_rest_api_id = module.api_gateway.rest_api_id
  api_gateway_resource_id = module.api_gateway.resource_id
  api_gateway_http_method = module.api_gateway.http_method 
}

module "lambda" {
  source                  = "./modules/lambda"

  # Input variables for Lambda module
  lambda_filename         = local.lambda_filename
  lambda_function_name    = local.lambda_function_name
  lambda_handler          = local.lambda_handler
  lambda_runtime          = local.lambda_runtime

  subnet_ids              = [ module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1] ]
  security_group_ids      = [ module.vpc.security_group_id ]
  sqs_queue_arn           = module.sqs_queues.queue_arn
  my_vpc_id               = module.vpc.vpc_id
}

module "rds" {
  source                              = "./modules/rds"
  # Input variables for RDS module
  allocated_storage                   = local.rds_allocated_storage
  engine                              = local.rds_engine
  engine_version                      = local.rds_engine_version
  instance_class                      = local.rds_instance_class
  db_name                             = local.rds_name
  db_username                         = local.rds_username
  db_password                         = local.rds_password
  parameter_group_name                = local.rds_parameter_group
  skip_final_snapshot                 = local.rds_skip_final_snapshot
  backup_retention_period             = local.rds_backup_retention
  vpc_security_group_ids              = [module.vpc.security_group_id]
  vpc_id                              = module.vpc.vpc_id
  iam_database_authentication_enabled = false
}

