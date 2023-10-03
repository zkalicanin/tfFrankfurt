resource "aws_sqs_queue" "my_queue" {
  name = var.queue_name
  vpc_configuration {
    subnet_ids = var.subnet_ids
  }
  delay_seconds = 90
  max_message_size = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10
  content_based_deduplication = false
  fifo_queue                 = false
  kms_data_key_reuse_period_seconds = 300
  name_prefix                = ""
  sqs_managed_sse_enabled    = true
  visibility_timeout_seconds = 60

  redrive_policy = jsonencode({
    "deadLetterTargetArn": aws_sqs_queue.my_queue_dlq.arn,
    "maxReceiveCount": 3 # Number of times a message can be received before going to the DLQ
  })
}

resource "aws_sqs_queue" "my_queue_dlq" {
  name = var.dlq_name
  vpc_configuration {
    subnet_ids = var.subnet_ids
  }
  delay_seconds                     = 90
  max_message_size                  = 262144
  message_retention_seconds         = 345600
  receive_wait_time_seconds         = 10
  content_based_deduplication       = false
  fifo_queue                        = false
  kms_data_key_reuse_period_seconds = 300
  name_prefix                       = ""
  sqs_managed_sse_enabled           = true
  visibility_timeout_seconds        = 30
}

resource "aws_sqs_queue_policy" "my_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "SQSDefaultPolicy",
    "Statement": [
      {
        "Sid": "Sid1564164737313",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "SQS:SendMessage",
        "Resource": aws_sqs_queue.my_queue.arn,
        "Condition": {
          "ArnEquals": {
            "aws:SourceArn": aws_sqs_queue.my_queue_dlq.arn
          }
        }
      }
    ]
  })
}


# Create an Integration to SQS
resource "aws_api_gateway_integration" "sqs_integration" {

  rest_api_id = var.api_gateway_rest_api_id
  resource_id = var.api_gateway_resource_id
  http_method = var.api_gateway_http_method

  integration_http_method   = "POST"
  type                      = "AWS"
  uri                       = aws_sqs_queue.my_queue.arn
  passthrough_behavior      = "NEVER"
}
# Create a Method Response
resource "aws_api_gateway_method_response" "method_response" {
  rest_api_id = var.api_gateway_rest_api_id
  resource_id = var.api_gateway_resource_id
  http_method = var.api_gateway_http_method
  status_code = "200"
}
# Create an Integration Response
resource "aws_api_gateway_integration_response" "integration_response" {
  rest_api_id = var.api_gateway_rest_api_id
  resource_id = var.api_gateway_resource_id
  http_method = var.api_gateway_http_method
  status_code = aws_api_gateway_method_response.method_response.status_code
}

# Create a CloudWatch Log Group for SQS
resource "aws_cloudwatch_log_group" "sqs_logs" {
  name = "SQSLogs"
}

# Create a CloudWatch Log Stream for SQS
resource "aws_cloudwatch_log_stream" "sqs_log_stream" {
  name           = "SQSLogStream"
  log_group_name = aws_cloudwatch_log_group.sqs_logs.name
}

# Create a CloudWatch Log Group for DLQ
resource "aws_cloudwatch_log_group" "dlq_logs" {
  name = "DLQLogs"
}


