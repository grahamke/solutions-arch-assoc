resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "DefaultVPC"
  }
}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "${var.region}a"

  tags = {
    Name = "DefaultSubnetA"
  }
}

resource "aws_instance" "default_vpc_instance" {
  instance_type               = "t2.micro"
  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  subnet_id                   = aws_default_subnet.default_subnet_a.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_ec2_key.key_name

  vpc_security_group_ids = [
    aws_security_group.default_vpc_instance_sg.id
  ]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # This enforces IMDSv2
  }

  tags = merge(var.common_tags, {
    Name = "DefaultVPCInstance"
  })
}

resource "aws_security_group" "default_vpc_instance_sg" {
  name        = "DefaultVPCInstanceSecurityGroup"
  description = "DefaultVPCInstanceSecurityGroup"
  vpc_id      = aws_default_vpc.default_vpc.id

  tags = merge(var.common_tags, {
    Name = "DefaultVPCInstanceSecurityGroup"
  })
}

resource "aws_vpc_security_group_ingress_rule" "default_vpc_instance_allow_ssh" {
  security_group_id = aws_security_group.default_vpc_instance_sg.id

  description = "Allow SSH from home"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "${chomp(data.http.my_ip.response_body)}/32"
}

resource "aws_vpc_security_group_egress_rule" "default_vpc_instance_allow_all" {
  security_group_id = aws_security_group.default_vpc_instance_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

output "default_vpc_instance_public_ip" {
  value = aws_instance.default_vpc_instance.public_ip
}

resource "aws_vpc_peering_connection" "demo_vpc_peering_connection" {
  vpc_id      = aws_vpc.demo_vpc.id
  peer_vpc_id = aws_default_vpc.default_vpc.id
  auto_accept = true
}

resource "aws_vpc_peering_connection_accepter" "demo_vpc_peering_connection_accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.demo_vpc_peering_connection.id
  auto_accept               = true
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_default_vpc.default_vpc.default_route_table_id

  tags = merge(var.common_tags, {
    Name = "DefaultVPCMainRouteTable"
  })
}

resource "aws_route" "vpc_request_route" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = aws_default_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.demo_vpc_peering_connection.id
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_default_vpc.default_vpc.id]
  }
}

resource "aws_route" "default_vpc_outbound_route" {
  route_table_id         = aws_default_route_table.default_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.default_igw.id
}

resource "aws_route" "vpc_accept_route" {
  route_table_id            = aws_default_route_table.default_route_table.id
  destination_cidr_block    = aws_vpc.demo_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.demo_vpc_peering_connection.id
}
