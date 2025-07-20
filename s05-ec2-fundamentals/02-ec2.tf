resource "aws_instance" "first_instance" {
  instance_type = "t2.micro" # Set the instance type to a t2.micro instance
  ami           = data.aws_ssm_parameter.al2023_ami.insecure_value # This is the default Amazon Linux AMI for the provider's region.
  key_name      = aws_key_pair.ec2_key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.launch_sg.id]

  # The following instance profile can be found in the next tf file. See comments in the next
  # file for reasons why this is done.
  iam_instance_profile = aws_iam_instance_profile.ec2_hands_on_profile.name

  user_data = <<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF

  tags = {
    # The name in the tag will appear on the EC2 instance console
    Name = "My First Instance"
  }
}

output "first_instance_ip" {
  value = aws_instance.first_instance.public_ip
}

###################################################
## Key pair for SSH access to the EC2 instance
###################################################
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "generated_key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# The file will be created in the current directory
# Expected to use a pem
resource "local_file" "private_key_pem" {
  filename        = "${path.module}/${aws_key_pair.ec2_key.key_name}.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}

output "identity_filename" {
  value = local_file.private_key_pem.filename
}

###################################################
## Replicating the created "Default" networking options
###################################################
resource "aws_security_group" "launch_sg" {
  name = "launch-sg-1"
}

# This is like clicking on the allow SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.launch_sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.ssh_cidr_block
}

# This is like clicking on the allow HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.launch_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.launch_sg.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Needed for routing HTTP and SSH
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = data.aws_vpc.default.main_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default_igw.id
  }
  tags = {
    Name = "Default Route Table"
  }
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}