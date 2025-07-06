###################################################
## Key pair for SSH access to the EC2 instance
###################################################
resource "tls_private_key" "this" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "this" {
  region = var.region
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
  tags       = var.tags
}

resource "local_file" "private_key_pem" {
  filename        = var.filename != null ? var.filename : "${path.module}/${var.key_name}.pem"
  content         = tls_private_key.this.private_key_pem
  file_permission = var.file_permission
}
