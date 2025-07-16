resource "aws_vpc_security_group_ingress_rule" "allow_bastion_http" {
  security_group_id = aws_security_group.bastion_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# Most of this hands on was adding, but ultimately removing rules