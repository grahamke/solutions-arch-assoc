resource aws_security_group launch_sg {
  name = "launch-sg-1"
}

# This is like clicking on the allow SSH
resource aws_vpc_security_group_ingress_rule allow_ssh {
  security_group_id = aws_security_group.launch_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

# This is like clicking on the allow HTTP
resource aws_vpc_security_group_ingress_rule allow_http {
  security_group_id = aws_security_group.launch_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource aws_vpc_security_group_egress_rule allow_all {
  security_group_id = aws_security_group.launch_sg.id
  ip_protocol = "-1"
  to_port = -1
  from_port = -1
  cidr_ipv4 = "0.0.0.0/0"
}

resource aws_default_vpc default_vpc {
  tags = {
    Name = "Default VPC"
  }
}

data aws_internet_gateway default_igw {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_default_vpc.default_vpc.id]
  }
}

# Needed for routing HTTP and SSH
resource aws_default_route_table default_route_table {
  default_route_table_id = aws_default_vpc.default_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default_igw.id
  }
  tags = {
    Name = "Default Route Table"
  }
}