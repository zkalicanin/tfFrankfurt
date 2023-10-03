output "rds_instance_id" {
  description = "ID of the created RDS instance"
  value       = aws_db_instance.my_db_instance_azure_ad.id
}

output "rds_endpoint" {
  description = "Endpoint of the created RDS instance"
  value       = aws_db_instance.my_db_instance_azure_ad.endpoint
}

# Define other outputs as needed

