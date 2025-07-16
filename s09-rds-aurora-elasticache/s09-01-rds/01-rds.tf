resource "aws_db_instance" "demo" {
  identifier = "database-1"

  engine                     = "mysql"
  engine_version             = var.mysql_version
  auto_minor_version_upgrade = true

  username = var.mysql_username
  password = var.mysql_password

  instance_class        = "db.t3.micro"
  storage_type          = "gp2"
  allocated_storage     = 20
  max_allocated_storage = 1000

  db_subnet_group_name   = aws_db_subnet_group.demo.name
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false

  monitoring_interval = 0

  db_name              = "mydb"
  parameter_group_name = "default.mysql8.4"
  option_group_name    = "default:mysql-8-4"

  backup_retention_period = 7

  # initially this was true, but we want to be able to delete the database on terraform destroy
  deletion_protection = false
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "demo" {
  name       = "demo"
  subnet_ids = data.aws_subnets.default.ids
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

resource "aws_security_group" "rds_sg" {
  name   = "demo-database-mysql"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "rds_sg_ingress_3306" {
  security_group_id = aws_security_group.rds_sg.id
  from_port         = 3306
  to_port           = 3306
  ip_protocol       = "tcp"
  cidr_ipv4         = "${var.personal_ip_address}/32"
}

output "mysql_hostname" {
  value = aws_db_instance.demo.address
}

output "mysql_port" {
  value = aws_db_instance.demo.port
}

output "mysql_username" {
  value = aws_db_instance.demo.username
}