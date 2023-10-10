variable "api_name" {
  description = "Name of the API"
  type        = string
}

variable "api_description" {
  description = "Description of the API"
  type        = string
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
}

variable "path_part" {
  description = "value of the path part"
  type = string
}

variable "usage_plan_name" {
  description = "Name of the usage plan"
  type        = string
}

variable "usage_plan_product_code" {
  description = "Product code of the usage plan"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
  

  

