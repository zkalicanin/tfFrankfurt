variable "region" {
  description = "AWS Region"
  type        = string
}  

variable "vpc_name" {
  description = "Name for the VPC"
  type = string
  default = "my_vpc"
}

variable "vpc_cidr" {
  description   = "CIDR block for the VPC"
  type          = string
  default       = "172.31.0.0/16"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
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
  default     = "my_igw"  # You can change this default value if needed
}

variable "route_cidr_block" {
  description = "CIDR block for the route"
  type        = string
  default     = "172.31.0.0/19"  # You can change this default value if needed
}

variable "route_table_name" {
  description = "Name of the route table"
  type        = string
  default     = "my_route_table"  # You can change this default value if needed
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)

}





