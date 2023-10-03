output "rds_instance_id" {
  description = "ID of the created RDS instance"
  value       = aws_db_instance.mssql_instance.id
}

output "rds_endpoint" {
  description = "Endpoint of the created RDS instance"
  value       = aws_db_instance.mssql_instance.endpoint
}
