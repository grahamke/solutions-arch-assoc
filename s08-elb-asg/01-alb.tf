resource "aws_instance" "compute" {
  count                       = var.alb_instances
  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  instance_type               = "t2.micro"
  associate_public_ip_address = true

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

  # Use this security group to allow HTTP traffic from the internet to the instance
  # vpc_security_group_ids = [module.launch_sg.sg_id]

  # Use this security group to allow HTTP traffic only from the ALB to the instance
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "compute-${count.index}" # Instead of My First Instance and My Second Instance, it'll be compute-0 and compute-1
  }
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

output "compute_ips" {
  value = aws_instance.compute.*.public_ip
}

# To use the direct public IPs of the instances, use this security group
module "launch_sg" {
  source = "../modules/default_vpc_sg"
}

resource "aws_lb" "alb" {
  name               = "DemoALB"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb_sg.id]
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "demo-sg-load-balancer"
  description = "Allow HTTP into ALB"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.alb_sg.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_lb_target_group" "tg" {
  name             = "demo-tg-alb"
  vpc_id           = data.aws_vpc.default.id
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"

  deregistration_delay = 30

  # This can be disabled to keep the ALB from balancing traffic across zones. There is no charge for
  # cross zone traffic balancing on an ALB.
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
  count            = length(aws_instance.compute)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.compute[count.index].id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "demo-sg-ec2"
  description = "Allow HTTP from ALB"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_alb" {
  security_group_id            = aws_security_group.ec2_sg.id
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out_from_instance" {
  security_group_id = aws_security_group.ec2_sg.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_lb_listener_rule" "error_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 5
  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
      message_body = "Not Found, custom error!"
    }
  }
  condition {
    path_pattern {
      values = ["/error"]
    }
  }
  tags = {
    Name = "DemoRule"
  }
}