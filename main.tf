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
  version                 = "~> 5.0"
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
  dlq_name                = local.sqs_dlq_name
  subnet_ids              = [ module.vpc.public_subnet_ids[0], module.vpc.public_subnet_ids[1] ]
  api_gateway_rest_api_id = module.api_gateway.rest_api_id
  api_gateway_resource_id = module.api_gateway.resource_id
  api_gateway_http_method = module.api_gateway.http_method 
}

module "lambda" {
  source                  = "./modules/lambda"
  # Input variables for Lambda module
  sqs_queue_url           = module.sqs_queues.queue_url
  sqs_dlq_url             = module.sqs_queues.dlq_url
  subnet_ids              = [ module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1] ]
  security_group_ids      = [ module.vpc.security_group_id ]

  sqs_queue_arn           = module.sqs_queues.queue_arn
}

module "rds" {
  source = "./modules/rds"
  # Input variables for RDS module
  allocated_storage                   = local.rds_allocated_storage
  engine                              = local.rds_engine
  engine_version                      = local.rds_engine_version
  instance_class                      = local.rds_instance_class
  name                                = local.rds_name
  db_username                         = local.rds_username
  db_password                         = local.rds_password
  parameter_group_name                = local.rds_parameter_group
  skip_final_snapshot                 = local.rds_skip_final_snapshot
  backup_retention_period             = local.rds_backup_retention
  vpc_security_group_ids              = [module.vpc.security_group_id]
  vpc_id                              = module.vpc.vpc_id
  iam_database_authentication_enabled = false

}

