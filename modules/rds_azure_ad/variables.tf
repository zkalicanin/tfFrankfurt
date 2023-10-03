variable "rds_instance_name" {
  description = "Name for the RDS instance"
  type        = string
}

variable "azure_ad_enabled" {
  description = "Enable Azure AD authentication for RDS"
  type        = bool
}


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

variable "security_group_id" {
  description = "Security group ID for the RDS instance"
  type        = string
}

variable "azure_ad_admin_username" {
  description = "Azure AD admin username"
  type        = string
}

variable "azure_ad_admin_password" {
  description = "Azure AD admin password"
  type        = string
}

variable "azure_ad_role_id" {
  description = "AWS IAM role ID for Azure AD authentication"
  type        = string
}

variable "azure_ad_role_arn" {
  description = "AWS IAM role ARN for Azure AD authentication"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
  


