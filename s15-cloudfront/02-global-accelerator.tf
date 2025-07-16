resource "aws_globalaccelerator_accelerator" "demo" {
  name = "MyFirstAccelerator"
}

resource "aws_globalaccelerator_listener" "demo" {
  accelerator_arn = aws_globalaccelerator_accelerator.demo.id
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}

resource "aws_globalaccelerator_endpoint_group" "us_east_1_demo" {
  listener_arn = aws_globalaccelerator_listener.demo.arn

  endpoint_group_region   = "us-east-1"
  traffic_dial_percentage = 100

  health_check_port             = 80
  health_check_protocol         = "HTTP"
  health_check_path             = "/"
  health_check_interval_seconds = 10
  threshold_count               = 3

  endpoint_configuration {
    endpoint_id = module.us_east_1_ec2.instance_id
    weight      = 128

    client_ip_preservation_enabled = true
  }
}

resource "aws_globalaccelerator_endpoint_group" "ap_south_1_demo" {
  listener_arn = aws_globalaccelerator_listener.demo.arn

  endpoint_group_region   = "ap-south-1"
  traffic_dial_percentage = 100

  health_check_port             = 80
  health_check_protocol         = "HTTP"
  health_check_path             = "/"
  health_check_interval_seconds = 10
  threshold_count               = 3

  endpoint_configuration {
    endpoint_id = module.ap_south_1_ec2.instance_id
    weight      = 128

    client_ip_preservation_enabled = true
  }
}

output "global_accelerator_dns_name" {
  description = "The Global Accelerator DNS Name"
  value       = aws_globalaccelerator_accelerator.demo.dns_name
}


module "us_east_1_vpc" {
  source = "../modules/simple_vpc"

  region               = "us-east-1"
  vpc_name             = "simple-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

module "us_east_1_security_group" {
  source = "../modules/sec_grp"

  region = "us-east-1"
  vpc_id = module.us_east_1_vpc.vpc_id
  name   = "global-accelerator-demo"
}

module "us_east_1_ec2" {
  source = "../modules/ec2"

  region        = "us-east-1"
  ami           = var.us_east_1_ami
  instance_type = "t2.micro"

  public_ip              = true
  vpc_security_group_ids = [module.us_east_1_security_group.sg_id]
  subnet_id              = module.us_east_1_vpc.public_subnet_ids[0]

  user_data = <<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f) in us-east-1</h1>" > /var/www/html/index.html
EOF
}

output "us_east_1_ec2_public_ip" {
  description = "The Public IP of the us-east-1 instance"
  value       = module.us_east_1_ec2.public_ip
}

output "us_east_1_ec2_public_dns" {
  description = "The Public DNS of the us-east-1 instance"
  value       = module.us_east_1_ec2.public_dns
}

module "ap_south_1_vpc" {
  source = "../modules/simple_vpc"

  region               = "ap-south-1"
  vpc_name             = "simple-vpc"
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

module "ap_south_1_security_group" {
  source = "../modules/sec_grp"

  region = "ap-south-1"
  vpc_id = module.ap_south_1_vpc.vpc_id
  name   = "global-accelerator-demo"
}

module "ap_south_1_ec2" {
  source = "../modules/ec2"

  region        = "ap-south-1"
  ami           = var.ap_south_1_ami
  instance_type = "t2.micro"

  public_ip              = true
  vpc_security_group_ids = [module.ap_south_1_security_group.sg_id]
  subnet_id              = module.ap_south_1_vpc.public_subnet_ids[0]

  user_data = <<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f) in ap-south-1</h1>" > /var/www/html/index.html
EOF
}

output "ap_south_1_ec2_public_ip" {
  description = "The Public IP of the ap-south-1 instance"
  value       = module.ap_south_1_ec2.public_ip
}

output "ap_south_1_ec2_public_dns" {
  description = "The Public DNS of the ap-south-1 instance"
  value       = module.ap_south_1_ec2.public_dns
}
