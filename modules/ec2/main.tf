resource "aws_instance" "instance" {
  region                      = var.region
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.public_ip

  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # This enforces IMDSv2
  }

  user_data = var.user_data

  tags = var.tags
}