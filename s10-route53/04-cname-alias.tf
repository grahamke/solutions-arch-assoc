resource "aws_route53_record" "ttl_demo" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "demo.${var.domain_name}"
  type    = "A"
  ttl     = 120
  records = [module.ap-southeast_ec2.public_ip]
}

resource "aws_route53_record" "cname_demo" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "myapp.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.alb.dns_name]
}

resource "aws_route53_record" "alias_demo" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "myalias.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "apex_demo" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name = var.domain_name
  type = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}