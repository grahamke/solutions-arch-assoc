###################################################
## Key pair for SSH access to the EC2 instance
###################################################
resource "tls_private_key" "private_key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

resource "aws_key_pair" "key_pair" {
  region     = var.region
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
  tags       = var.tags
}

resource "local_file" "identity_file" {
  filename        = var.filename != null ? var.filename : "${path.module}/${var.key_name}.pem"
  content         = tls_private_key.private_key.private_key_pem
  file_permission = var.file_permission
}
