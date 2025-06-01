##################################################
## Bastion Host
##################################################
resource "tls_private_key" "bastion_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_ec2_key" {
  key_name   = "generated_key"
  public_key = tls_private_key.bastion_ec2_key.public_key_openssh
}

resource "local_file" "bastion_key_pem" {
  filename        = "${path.module}/${aws_key_pair.bastion_ec2_key.key_name}.pem"
  content         = tls_private_key.bastion_ec2_key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "bastion_host" {
  instance_type               = "t2.micro"
  ami                         = var.amazon_linux_2023_ami_id
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_ec2_key.key_name

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "hello world" > /var/www/html/index.html
              EOF

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # This enforces IMDSv2
  }

  tags = merge(var.common_tags, {
    Name = "BastionHost"
  })

  # add for IPv6
  ipv6_address_count = 1
}

output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "bastion_host_public_ipv6" {
  value = aws_instance.bastion_host.ipv6_addresses
}

resource "aws_security_group" "bastion_sg" {
  name        = "BastionSG"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  tags = merge(var.common_tags, {
    Name = "BastionSG"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.bastion_sg.id

  cidr_ipv4   = var.home_ip_address
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

# add for IPv6
resource "aws_vpc_security_group_ingress_rule" "bastion_allow_ipv6_ssh" {
  security_group_id = aws_security_group.bastion_sg.id

  cidr_ipv6   = "::/0"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

# Rule for IPv4 outbound
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1
  cidr_ipv4   = "0.0.0.0/0"
}

# add for IPv6
# Separate rule for IPv6 outbound
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv6" {
  security_group_id = aws_security_group.bastion_sg.id
  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1
  cidr_ipv6   = "::/0"
}

##################################################
## Private Host
##################################################
resource "tls_private_key" "private_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "private_ec2_key" {
  key_name   = "private_key"
  public_key = tls_private_key.private_ec2_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  filename        = "${path.module}/${aws_key_pair.private_ec2_key.key_name}.pem"
  content         = tls_private_key.private_ec2_key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "private_host" {
  instance_type               = "t2.micro"
  ami                         = var.amazon_linux_2023_ami_id
  subnet_id                   = aws_subnet.private_a.id
  key_name                    = aws_key_pair.private_ec2_key.key_name

  vpc_security_group_ids = [
    aws_security_group.private_sg.id
  ]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # This enforces IMDSv2
  }

  tags = merge(var.common_tags, {
    Name = "PrivateHost"
  })

  # added for VPC Endpoints
  iam_instance_profile = aws_iam_instance_profile.demo_ec2_s3_read_only_instance_profile.name
}

output aws_instance_private_host_private_ip {
  value = aws_instance.private_host.private_ip
}

resource "aws_security_group" "private_sg" {
  name        = "PrivateSG"
  description = "Secure Traffic to Private subnet"
  vpc_id      = aws_vpc.demo_vpc.id

  tags = merge(var.common_tags, {
    Name = "PrivateSG"
  })
}

resource "aws_vpc_security_group_ingress_rule" "private_sg_ingress" {
  security_group_id            = aws_security_group.private_sg.id
  description                  = "Allow SSH traffic from bastion"
  referenced_security_group_id = aws_security_group.bastion_sg.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}