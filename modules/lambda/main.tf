
# Lambda Archive File
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"     // what is the path to the lambda code?
  output_path = "${path.module}/lambda.zip" // what is the path to the lambda code?
}
# Lambda IAM Role
resource "aws_iam_role" "lambda-iam-role" {
  name = "lambda-iam-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}
# Lambda IAM Policy
resource "aws_iam_policy" "lambda-iam-policy" { 
  name = "lambda-iam-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"

    },
    {
      "Action": [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
      ],
      "Effect": "Allow",
      "Resource": var.sqs_queue_arn
    }
    ]
    
  })
}
# Lambda IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "lambda-iam-policy-attachment" {
  role        = aws_iam_role.lambda-iam-role.name
  policy_arn  = aws_iam_policy.lambda-iam-policy.arn
}
# Lambda Function
resource "aws_lambda_function" "lambda" {
    filename              = var.lambda_filename
    function_name         = var.lambda_function_name
    role                  = "${aws_iam_role.lambda-iam-role.arn}"
    handler               = var.lambda_handler
    source_code_hash      = "${data.archive_file.lambda_zip.output_base64sha256}"
    runtime               = var.lambda_runtime
    publish               = true
    vpc_config {
      subnet_ids          = var.subnet_ids
      security_group_ids  = var.security_group_ids
    }
}
# Create S3 Bucket to store the Lambda
resource "aws_s3_bucket" "lambda_deployment_bucket" {
  bucket = "my-lambda-deployment-bucket"

  // acl = "private"
  // versioning {
    // enabled = true
  // }
  lifecycle {
    prevent_destroy = true
  }
}
# Lambda Permission to Consume Messages from SQS
resource "aws_lambda_permission" "sqs_permission" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = var.sqs_queue_arn
}

# Trigger Lambda Function on SQS Message
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn                    = var.sqs_queue_arn
  function_name                       = aws_lambda_function.lambda.function_name
  batch_size                          = 10 # Adjust as needed
  maximum_batching_window_in_seconds  = 60 # Adjust as needed
}

# Create a CloudWatch Logs Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
}

# Grant Lambda Permission to Write Logs
resource "aws_lambda_permission" "logs_permission" {
  statement_id  = "AllowExecutionToCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "logs.amazonaws.com"
}

# Create a CloudWatch Log Stream for Lambda
resource "aws_cloudwatch_log_stream" "lambda_log_stream" {
  name           = aws_lambda_function.lambda.function_name
  log_group_name = aws_cloudwatch_log_group.lambda_logs.name
}
resource "aws_security_group" "lambda_security_group" {
  vpc_id = var.my_vpc_id
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}