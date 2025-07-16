##################################
# Failover Routing Policy
##################################
resource "aws_route53_record" "failover1" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "failover.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  failover_routing_policy {
    type = "PRIMARY"
  }
  set_identifier  = "EU"
  records         = [module.eu_central_ec2.public_ip]
  health_check_id = aws_route53_health_check.eu_central_1.id
}

resource "aws_route53_record" "failover2" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "failover.${var.domain_name}"
  type    = "A"
  ttl     = "60"
  failover_routing_policy {
    type = "SECONDARY"
  }
  set_identifier  = "US"
  records         = [module.us-east_ec2.public_ip]
  health_check_id = aws_route53_health_check.us_east_1.id
}

##################################
# Geolocation Routing Policy
##################################
resource "aws_route53_record" "geolocation1" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "geo.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  geolocation_routing_policy {
    continent = "AS"
  }
  set_identifier = "Asia"
  records        = [module.ap-southeast_ec2.public_ip]
}

resource "aws_route53_record" "geolocation2" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "geo.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  geolocation_routing_policy {
    country = "US"
  }
  set_identifier = "US"
  records        = [module.us-east_ec2.public_ip]
}

resource "aws_route53_record" "geolocation3" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "geo.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  geolocation_routing_policy {
    country = "*"
  }
  set_identifier = "Default EU"
  records        = [module.eu_central_ec2.public_ip]
}

##################################
# Multivalue Answer Routing Policy
##################################
resource "aws_route53_record" "multivalue1" {
  zone_id                          = data.aws_route53_zone.demo.zone_id
  name                             = "multi.${var.domain_name}"
  type                             = "A"
  ttl                              = "60"
  set_identifier                   = "US"
  multivalue_answer_routing_policy = true
  records                          = [module.us-east_ec2.public_ip]
  health_check_id                  = aws_route53_health_check.us_east_1.id
}

resource "aws_route53_record" "multivalue2" {
  zone_id                          = data.aws_route53_zone.demo.zone_id
  name                             = "multi.${var.domain_name}"
  type                             = "A"
  ttl                              = "60"
  set_identifier                   = "Asia"
  multivalue_answer_routing_policy = true
  records                          = [module.ap-southeast_ec2.public_ip]
  health_check_id                  = aws_route53_health_check.ap_south_1.id
}

resource "aws_route53_record" "multivalue3" {
  zone_id                          = data.aws_route53_zone.demo.zone_id
  name                             = "multi.${var.domain_name}"
  type                             = "A"
  ttl                              = "60"
  set_identifier                   = "EU"
  multivalue_answer_routing_policy = true
  records                          = [module.eu_central_ec2.public_ip]
  health_check_id                  = aws_route53_health_check.eu_central_1.id
}
