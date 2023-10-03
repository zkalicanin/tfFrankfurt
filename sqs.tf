
module "sqs_queues" {
  source    = "./modules/sqs"
  queue_name = "my_queue"
  dlq_name   = "my_queue_dlq"
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
}


