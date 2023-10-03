

variable "queue_name" {
  description = "Name of the SQS Queue"
  type        = string
}

variable "dlq_name" {
  description = "Name of the Dead-Letter Queue (DLQ)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the SQS Queue"
  type        = list(string) // check this
}

variable "api_gateway_rest_api_id" {
  description = "ID of the API Gateway"
  type        = number
}

variable "api_gateway_resource_id" {
  description = "ID of the API Gateway Resource"
  type        = number
}

variable "api_gateway_http_method" {
  description = "HTTP Method for the API Gateway"
  type        = string
  default     = "POST"
}

  
  

