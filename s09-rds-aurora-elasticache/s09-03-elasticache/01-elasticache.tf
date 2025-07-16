resource "aws_elasticache_cluster" "demo" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1 # no replicas
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.bar.name
  security_group_ids   = [aws_security_group.nondefault.id]

  az_mode                      = "single-az" # disables Multi-AZ
  preferred_availability_zones = [data.aws_availability_zones.available.names[0]]
}

resource "aws_elasticache_subnet_group" "bar" {
  name       = "elasticache-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_security_group" "nondefault" {
  name        = "elasticache-security-group"
  description = "Allow Redis inbound traffic"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "redis" {
  security_group_id = aws_security_group.nondefault.id
  from_port         = 6379
  to_port           = 6379
  ip_protocol       = "tcp"
  cidr_ipv4         = data.aws_vpc.default.cidr_block
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

data "aws_availability_zones" "available" {
  state = "available"
}