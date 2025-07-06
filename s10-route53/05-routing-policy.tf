##################################
# Simple Routing
##################################
resource "aws_route53_record" "simple_demo" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "simple.${var.domain_name}"
  type    = "A"
  ttl     = 3
  records = [module.ap-southeast_ec2.public_ip, module.us-east_ec2.public_ip]
}

##################################
# Weighted Routing
##################################
resource "aws_route53_record" "weighted_demo1" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "weighted.${var.domain_name}"
  type    = "A"
  ttl     = 3

  set_identifier = "SOUTHEAST"
  weighted_routing_policy {
    weight = 10
  }
  records = [module.ap-southeast_ec2.public_ip]
}

resource "aws_route53_record" "weighted_demo2" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "weighted.${var.domain_name}"
  type    = "A"
  ttl     = 3

  set_identifier = "US EAST"
  weighted_routing_policy {
    weight = 70
  }
  records = [module.us-east_ec2.public_ip]
}

resource "aws_route53_record" "weighted_demo3" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "weighted.${var.domain_name}"
  type    = "A"
  ttl     = 3

  set_identifier = "EU"
  weighted_routing_policy {
    weight = 20
  }
  records = [module.eu_central_ec2.public_ip]
}

##################################
# Latency Based Routing
##################################
resource aws_route53_record latency_demo1 {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "latency.${var.domain_name}"
  type    = "A"
  ttl     = 300

  set_identifier = "ap-southeast-1"
  latency_routing_policy {
    region = "ap-southeast-1"
  }
  records = [module.ap-southeast_ec2.public_ip]
}

resource aws_route53_record latency_demo2 {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "latency.${var.domain_name}"
  type    = "A"
  ttl     = 300

  set_identifier = "us-east-1"
  latency_routing_policy {
    region = "us-east-1"
  }
  records = [module.us-east_ec2.public_ip]
}

resource aws_route53_record latency_demo3 {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "latency.${var.domain_name}"
  type    = "A"
  ttl     = 300

  set_identifier = "eu-central-1"
  latency_routing_policy {
    region = "eu-central-1"
  }
  records = [module.eu_central_ec2.public_ip]
}