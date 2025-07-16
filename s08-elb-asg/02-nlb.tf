resource "aws_lb" "nlb" {
  name               = "DemoNLB"
  internal           = false
  load_balancer_type = "network"
  ip_address_type    = "ipv4"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.nlb_sg.id]
}

output "nlb_dns" {
  value       = aws_lb.nlb.dns_name
  description = "NLB DNS"
}

resource "aws_security_group" "nlb_sg" {
  name        = "demo-sg-nlb"
  description = "Demo SG for NLB"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "nlb_allow_http" {
  security_group_id = aws_security_group.nlb_sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "nlb_allow_all_out" {
  security_group_id = aws_security_group.nlb_sg.id
  ip_protocol       = "-1"
  to_port           = -1
  from_port         = -1
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_allow_nlb" {
  security_group_id            = aws_security_group.ec2_sg.id
  ip_protocol                  = "tcp"
  to_port                      = 80
  from_port                    = 80
  referenced_security_group_id = aws_security_group.nlb_sg.id
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_lb_target_group" "nlb_tg" {
  name     = "demo-tg-nlb"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    port                = "traffic-port"
    path                = "/"
    matcher             = "200-299"
    timeout             = 2
    interval            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "nlb_tg_attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = aws_instance.compute[count.index].id
  port             = 80
}