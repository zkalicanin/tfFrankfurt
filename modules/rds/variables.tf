

variable "allocated_storage" {
  description = "Allocated storage for the RDS instance"
  type        = number
}

variable "engine" {
  description = "Database engine (e.g., sqlserver-ex)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t2.micro)"
  type        = string
}

variable "name" {
  description = "Name for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Database admin username"
  type        = string
}
variable "db_password" {
  description = "Database admin password"
  type        = string
}
variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
}
variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot"
  type        = bool
}
variable "backup_retention_period" {
  description = "Backup retention period (in days)"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}



