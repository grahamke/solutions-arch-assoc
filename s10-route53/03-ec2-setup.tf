#####################################
## AWS eu-central-1 EC2
#####################################
module "eu_central_ec2" {
  source = "../modules/ec2"

  region    = "eu-central-1"
  ami       = var.eu_central_1_ami
  key_name  = module.eu_central_ec2_key_pair.key_name
  public_ip = true

  vpc_security_group_ids = [module.eu_central_sg.sg_id]
  subnet_id              = module.eu_central_vpc.subnet_ids[0]

  user_data = local.user_data_script
}

module "eu_central_ec2_key_pair" {
  source = "../modules/key_pair"

  region   = "eu-central-1"
  key_name = "generated_key"
  filename = "${path.module}/generated_key_eu.pem"
  tags = {
    Name = "EC2 Key Pair"
  }
}

module "eu_central_sg" {
  source = "../modules/sec_grp"

  region         = "eu-central-1"
  ssh_cidr_block = "${chomp(data.http.my_ip.response_body)}/32"
  name           = "eu-central-1-sg"
  vpc_id         = module.eu_central_vpc.vpc_id
}

module "eu_central_vpc" {
  source     = "../modules/simple_vpc"
  region     = "eu-central-1"
  vpc_name   = "eu-central-1-vpc"
  cidr_block = "172.16.0.0/24"
}

output "eu_central_ec2_public_ip" {
  value = module.eu_central_ec2.public_ip
}

#####################################
## AWS us-east-1 EC2
#####################################
module "us-east_ec2" {
  source = "../modules/ec2"

  region    = "us-east-1"
  ami       = var.us_east_1_ami
  key_name  = module.us-east_ec2_key_pair.key_name
  public_ip = true

  vpc_security_group_ids = [module.us-east_sg.sg_id]
  subnet_id              = module.us-east_vpc.subnet_ids[0]

  user_data = local.user_data_script
}

module "us-east_ec2_key_pair" {
  source = "../modules/key_pair"

  region   = "us-east-1"
  key_name = "generated_key"
  filename = "${path.module}/generated_key_us.pem"
  tags = {
    Name = "EC2 Key Pair"
  }
}

module "us-east_sg" {
  source = "../modules/sec_grp"

  region         = "us-east-1"
  ssh_cidr_block = "${chomp(data.http.my_ip.response_body)}/32"
  name           = "us-east-1-sg"
  vpc_id         = module.us-east_vpc.vpc_id
}

module "us-east_vpc" {
  source     = "../modules/simple_vpc"
  region     = "us-east-1"
  vpc_name   = "us-east-1-vpc"
  cidr_block = "172.16.0.0/24"
}

output "us-east_ec2_public_ip" {
  value = module.us-east_ec2.public_ip
}

#####################################
## AWS ap-southeast-1 EC2
#####################################
module "ap-southeast_ec2" {
  source = "../modules/ec2"

  region    = "ap-southeast-1"
  ami       = var.ap_southeast_1_ami
  key_name  = module.ap-southeast_ec2_key_pair.key_name
  public_ip = true

  vpc_security_group_ids = [module.ap-southeast_sg.sg_id]
  subnet_id              = module.ap-southeast_vpc.subnet_ids[0]

  user_data = local.user_data_script
}

module "ap-southeast_ec2_key_pair" {
  source = "../modules/key_pair"

  region   = "ap-southeast-1"
  key_name = "generated_key"
  filename = "${path.module}/generated_key_ap.pem"
  tags = {
    Name = "EC2 Key Pair"
  }
}

module "ap-southeast_sg" {
  source = "../modules/sec_grp"

  region         = "ap-southeast-1"
  ssh_cidr_block = "${chomp(data.http.my_ip.response_body)}/32"
  name           = "ap-southeast-1-sg"
  vpc_id         = module.ap-southeast_vpc.vpc_id
}

module "ap-southeast_vpc" {
  source     = "../modules/simple_vpc"
  region     = "ap-southeast-1"
  vpc_name   = "ap-southeast-1-vpc"
  cidr_block = "172.16.0.0/24"
}

output "ap-southeast_ec2_public_ip" {
  value = module.ap-southeast_ec2.public_ip
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

locals {
  user_data_script = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd

    # Get instance metadata using IMDSv2
    TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    EC2_AVAIL_ZONE=`curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone`

    echo "<h1>Hello world from $(hostname -f) in AZ $EC2_AVAIL_ZONE</h1>" > /var/www/html/index.html
  EOF
}

resource "aws_lb" "alb" {
  region             = "eu-central-1"
  name               = "DemoRoute53ALB"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = module.eu_central_vpc.subnet_ids
  security_groups    = [aws_security_group.alb_sg.id]
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}

resource "aws_security_group" "alb_sg" {
  region      = "eu-central-1"
  name        = "route53-alb-sg-load-balancer"
  description = "Allow HTTP into ALB"
  vpc_id      = module.eu_central_vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  region            = "eu-central-1"
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  region            = "eu-central-1"
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_lb_target_group" "tg" {
  region           = "eu-central-1"
  name             = "demo-route53-tg-alb"
  vpc_id           = module.eu_central_vpc.vpc_id
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"

  deregistration_delay = 30

  load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/"
    matcher             = "200-299"
    timeout             = 5
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # enable to see stickiness in action
  stickiness {
    enabled         = false
    type            = "lb_cookie"
    cookie_duration = 86400 # one day
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  region           = "eu-central-1"
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = module.eu_central_ec2.instance_id
  port             = 80
}

resource "aws_lb_listener" "http" {
  region            = "eu-central-1"
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}