# Create AWS VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "my_subnet_public" {
  count                     = length(var.public_subnet_cidrs)
  vpc_id                    = var.vpc_id
  cidr_block                = var.public_subnet_cidrs[count.index]
  availability_zone         = "var.region${element(["a", "b"], count.index)}"
  map_public_ip_on_launch   = true
  tags = {
    Name                    = "my_subnet_public_${count.index + 1}"
  }
}

resource "aws_subnet" "my_subnet_private" {
  count           = length(var.private_subnet_cidrs)
  vpc_id          = var.vpc_id
  cidr_block      = var.private_subnet_cidrs[count.index]
  availability_zone = "var.region${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = false
  tags = {
    Name = "my_subnet_private_${count.index + 1}"
  }
}

# Networking

# Create AWS Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = var.internet_gateway_name
  }
}

# Create AWS Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.my_igw.id 
  }
  tags = {
    Name = var.route_table_name
  }
}

# Create AWS Route Table Associations for public subnets
resource "aws_route_table_association" "my_route_table_association_public" {
  count       = length(var.public_subnet_ids)
  subnet_id   = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.my_route_table.id
}


  











