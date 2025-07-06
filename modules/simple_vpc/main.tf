resource "aws_vpc" "vpc" {
  region     = var.region
  cidr_block = var.cidr_block
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

resource "aws_subnet" "subnet_a" {
  region     = var.region
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 1, 0)
  availability_zone = "${var.region}a"
  tags = {
    Name = "SubnetA ${var.vpc_name}"
  }
}

resource "aws_subnet" "subnet_b" {
  region     = var.region
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 1, 1)
  availability_zone = "${var.region}b"
  tags = {
    Name = "SubnetB ${var.vpc_name}"
  }
}

resource "aws_route_table_association" "subnet_a_route_table_association" {
  region         = var.region
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.subnet_a.id
}

resource "aws_route_table_association" "subnet_b_route_table_association" {
  region         = var.region
  route_table_id = aws_route_table.route_table.id
  subnet_id      = aws_subnet.subnet_b.id
}