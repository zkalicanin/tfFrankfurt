variable "region" {
  description = "AWS Region"
  type        = string
}  

variable "vpc_name" {
  description = "Name for the VPC"
  type = string
}

variable "vpc_cidr" {
  description   = "CIDR block for the VPC"
  type          = string
}

variable "public_subnet_cidrs" {
  description   = "List of CIDR blocks for public subnets"
  type          = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "internet_gateway_name" {
  description = "Name of the Internet Gateway"
  type        = string  
}

variable "route_cidr_block" {
  description = "CIDR block for the route"
  type        = string
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
}






