resource "aws_security_group" "sec_grp" {
  region = var.region
  name   = var.name
  vpc_id = var.vpc_id
}

# This is like clicking on the allow SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  region            = var.region
  security_group_id = aws_security_group.sec_grp.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.ssh_cidr_block
}

# This is like clicking on the allow HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  region            = var.region
  security_group_id = aws_security_group.sec_grp.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  region            = var.region
  security_group_id = aws_security_group.sec_grp.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}