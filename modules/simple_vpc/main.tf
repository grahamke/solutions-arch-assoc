resource "aws_vpc" "vpc" {
  region               = var.region
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  region = var.region
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "IGW VPC ${var.vpc_name}"
  }
}

resource "aws_route_table" "route_table" {
  region = var.region
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Route Table VPC ${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet_a" {
  region                  = var.region
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 2, 0)
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags = {
    Name = "SubnetA ${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet_b" {
  region                  = var.region
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 2, 1)
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"
  tags = {
    Name = "SubnetB ${var.vpc_name}"
  }
}

resource "aws_route_table_association" "subnet_a_route_table_association" {
  region         = var.region
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.public_subnet_a.id
}

resource "aws_route_table_association" "subnet_b_route_table_association" {
  region         = var.region
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.public_subnet_b.id
}

resource "aws_subnet" "private_subnet_a" {
  region                  = var.region
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 2, 2)
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}a"
  tags = {
    Name = "Private SubnetA ${var.vpc_name}"
  }
}

resource "aws_subnet" "private_subnet_b" {
  region                  = var.region
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 2, 3)
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}b"
  tags = {
    Name = "Private SubnetB ${var.vpc_name}"
  }
}