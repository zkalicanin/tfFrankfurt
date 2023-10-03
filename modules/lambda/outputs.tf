output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value = "${aws_lambda_function.lambda.arn}"
  
}

output "lambda_function_invoke_arn" {
  description = "ARN to be used for invoking Lambda function from API Gateway"
  value = "${aws_lambda_function.lambda.invoke_arn}"  
}
  
output "lambda_function_name" {
  description = "Name of the created Lambda function"
  value = "${aws_lambda_function.lambda.function_name}" 
}

output "lambda_function_id" {
  description = "ID of the created Lambda function"
  value = "${aws_lambda_function.lambda.id}" 
}
  