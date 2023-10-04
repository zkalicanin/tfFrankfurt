
/*
module "lambda" {
  source                  = "./modules/lambda"
  # Input variables for Lambda module
  sqs_queue_url           = module.sqs_queues.queue_url
  sqs_dlq_url             = module.sqs_queues.dlq_url
  subnet_ids              = [ module.vpc.private_subnet_ids[0], module.vpc.private_subnet_ids[1] ]
  security_group_ids      = [ module.vpc.security_group_id ]

  sqs_queue_arn           = module.sqs_queues.queue_arn
}
*/
