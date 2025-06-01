resource "aws_subnet" "public_a" {
  vpc_id     = aws_vpc.demo_vpc.id
  availability_zone = "${var.region}a"
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet-a"
  }

  # add for IPv6
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = cidrsubnet(aws_vpc.demo_vpc.ipv6_cidr_block, 8, 1)
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.demo_vpc.id
  availability_zone = "${var.region}b"
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet-b"
  }

  # add for IPv6
  assign_ipv6_address_on_creation = true
  ipv6_cidr_block = cidrsubnet(aws_vpc.demo_vpc.ipv6_cidr_block, 8, 2)
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.demo_vpc.id
  availability_zone = "${var.region}a"
  cidr_block = "10.0.16.0/20"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-subnet-a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.demo_vpc.id
  availability_zone = "${var.region}b"
  cidr_block = "10.0.32.0/20"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-subnet-b"
  }
}