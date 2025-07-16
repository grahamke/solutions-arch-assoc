# Do I need this to get traffic out? It didn't sound like I did.
# But I could not get the private subnet to route to the internet without it.
resource "aws_vpc_security_group_egress_rule" "allow_ngw_all_outbound" {
  security_group_id = aws_security_group.private_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_nat_gateway" "demo_nat_gw" {
  allocation_id     = aws_eip.demo_eip.id
  subnet_id         = aws_subnet.public_a.id
  connectivity_type = "public"
  tags = {
    Name = "DemoNATGW"
  }
}

resource "aws_eip" "demo_eip" {
  domain = "vpc"
  tags = {
    Name = "DemoEIP"
  }
}

output "eip_ip_address" {
  value = aws_eip.demo_eip.public_ip
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.demo_nat_gw.id
}