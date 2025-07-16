resource "aws_route53_record" "test" {
  zone_id = data.aws_route53_zone.demo.zone_id
  name    = "test.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["11.22.33.44"]
}

