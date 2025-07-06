resource aws_route53_health_check us_east_1 {
  ip_address        = module.us-east_ec2.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "us-east-1"
  }
}

resource aws_route53_health_check eu_central_1 {
  ip_address        = module.eu_central_ec2.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "eu-central-1"
  }
}

resource aws_route53_health_check ap_south_1 {
  ip_address        = module.ap-southeast_ec2.public_ip
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "ap-southeast-1"
  }
}

resource aws_route53_health_check calculated {
  type                   = "CALCULATED"
  child_healthchecks = [aws_route53_health_check.us_east_1.id,
                        aws_route53_health_check.eu_central_1.id,
                        aws_route53_health_check.ap_south_1.id]
  child_health_threshold = 3
}