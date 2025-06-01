resource aws_egress_only_internet_gateway demo_eigw {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "DemoEIGW"
  }
}

resource aws_route egress_only_route {
  route_table_id = aws_route_table.private_rt.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id = aws_egress_only_internet_gateway.demo_eigw.id
}