resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "generated_key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  filename        = "${path.module}/${aws_key_pair.ec2_key.key_name}.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "ec2_handson" {
  instance_type        = "t2.micro" # Set the instance type to a t2.micro instance
  ami                  = var.amazon_linux_2023_ami_id
  key_name             = aws_key_pair.ec2_key.key_name                     # Use the generated key pair for SSH access
  iam_instance_profile = aws_iam_instance_profile.ec2_handson_profile.name # Use the IAM instance profile for SSM access

  vpc_security_group_ids      = [aws_security_group.allow_ssh.id] # Use the security group for the EC2 instance
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # This enforces IMDSv2
  }

  tags = {
    Name = "ec2-handson"
  }
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_handson_role" {
  name               = "ec2_handson_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_iam_read_only" {

  role       = aws_iam_role.ec2_handson_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_handson_profile" {
  name = "ec2_handson_profile"
  role = aws_iam_role.ec2_handson_role.name
}