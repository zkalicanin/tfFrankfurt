variable "api_name" {
  description = "Name of the API"
  type        = string
  default     = "my-api"
}

variable "api_description" {
  description = "Description of the API"
  type        = string
  default     = "Description of the API"
}

variable "stage_name" {
  description = "Name of the API Gateway stage"
  type        = string
  default     = "dev"
}

variable "path_part" {
  description = "value of the path part"
  type = string
  default = "myresource"
}

variable "usage_plan_name" {
  description = "Name of the usage plan"
  type        = string
  default     = "my-usage-plan"
}

variable "usage_plan_product_code" {
  description = "Product code of the usage plan"
  type        = string
  default     = "my-product-code"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
  

  

