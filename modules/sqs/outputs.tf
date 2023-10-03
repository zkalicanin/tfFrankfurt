
output "queue_url" {
  value       = aws_sqs_queue.my_queue.id
  description = "URL of the SQS Queue"
}

output "dlq_url" {
  value       = aws_sqs_queue.my_queue_dlq.id
  description = "URL of the Dead-Letter Queue (DLQ)"
}

output "queue_arn" {
  value       = aws_sqs_queue.my_queue.arn
  description = "ARN of the SQS Queue"
}

output "dlq_arn" {
  value       = aws_sqs_queue.my_queue_dlq.arn
  description = "ARN of the Dead-Letter Queue (DLQ)"
}




