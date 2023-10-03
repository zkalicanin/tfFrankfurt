variable "lambda_zip_dir" {
  description = "Path to the directory containing Lambda code"
  type = string
}

variable "lambda_function_name" {
  description = "Name for the Lambda function"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to place Lambda function in"
  type = list(string)
}
variable "security_group_ids" {
  description = "List of security group IDs to place Lambda function in"
  type = list(string)
}

variable "sqs_queue_arn" {
  description = "ARN of the SQS queue to be used by Lambda function"
  type = string
}
  

  

  

