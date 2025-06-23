resource aws_rds_cluster demo {
  cluster_identifier = "database-2"

  engine             = "aurora-mysql"
  engine_version = var.aurora_mysql_version

  master_username = var.mysql_username
  master_password = var.mysql_password

  storage_type = "aurora"

  # Use the first 3 AZs (or fewer if less than 3 are available)
  availability_zones = slice(data.aws_availability_zones.available.names, 0,
    min(3, length(data.aws_availability_zones.available.names)))

  db_subnet_group_name = aws_db_subnet_group.demo.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  database_name = "mydb"

  db_cluster_parameter_group_name = "default.aurora-mysql8.0"

  backup_retention_period = 1

  storage_encrypted  = true
  kms_key_id = data.aws_kms_key.rds.arn

  skip_final_snapshot = true
}

resource aws_rds_cluster_instance primary {
  identifier = "database-2-primary"

  cluster_identifier = aws_rds_cluster.demo.id

  instance_class  = "db.t3.medium"
  engine          = aws_rds_cluster.demo.engine
  engine_version  = aws_rds_cluster.demo.engine_version

  availability_zone  = data.aws_availability_zones.available.names[0]

  publicly_accessible = true

  db_parameter_group_name = "default.aurora-mysql8.0"
}

resource aws_rds_cluster_instance reader {
  identifier = "database-2-reader"

  cluster_identifier = aws_rds_cluster.demo.id

  instance_class  = "db.t3.medium"
  engine          = aws_rds_cluster.demo.engine
  engine_version  = aws_rds_cluster.demo.engine_version

  availability_zone  = data.aws_availability_zones.available.names[1]

  publicly_accessible = true

  db_parameter_group_name = "default.aurora-mysql8.0"
}

# Get all available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Get subnets in the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get detailed subnet information
data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

# Create a local variable with subnets grouped by AZ
locals {
  subnets_by_az = {
    for id, subnet in data.aws_subnet.selected :
    subnet.availability_zone => id...
  }

  # Get the first subnet from each AZ
  selected_subnet_ids = [
    for az in slice(data.aws_availability_zones.available.names, 0,
      min(3, length(data.aws_availability_zones.available.names))) :
    try(local.subnets_by_az[az][0], null)
  ]
}

# Use the filtered subnet IDs
resource "aws_db_subnet_group" "demo" {
  name       = "demo"
  subnet_ids = compact(local.selected_subnet_ids)
}

resource "aws_security_group" "aurora_sg" {
  name   = "aurora-mysql-sg"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "aurora_mysql" {
  security_group_id = aws_security_group.aurora_sg.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "${var.personal_ip_address}/32"
}

data aws_kms_key rds {
  key_id = "alias/aws/rds"
}

output "aurora_cluster_endpoint" {
  description = "Writer endpoint for the Aurora cluster"
  value       = aws_rds_cluster.demo.endpoint
}

output "aurora_reader_endpoint" {
  description = "Reader endpoint for the Aurora cluster"
  value       = aws_rds_cluster.demo.reader_endpoint
}

output "aurora_cluster_instances" {
  description = "Individual instance endpoints"
  value = {
    primary = aws_rds_cluster_instance.primary.endpoint
    reader  = aws_rds_cluster_instance.reader.endpoint
  }
}

resource aws_rds_cluster_endpoint static {
  cluster_identifier          = aws_rds_cluster.demo.id
  cluster_endpoint_identifier = "static"
  custom_endpoint_type        = "READER" # READER or ANY

  static_members = [aws_rds_cluster_instance.reader.id]
}

output "aurora_cluster_static_endpoint" {
  description = "Static endpoint for the Aurora cluster"
  value       = aws_rds_cluster_endpoint.static.endpoint
}
