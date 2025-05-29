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

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_handson" {
  instance_type        = "t2.micro"                                        # Set the instance type to a t2.micro instance
  ami                  = data.aws_ami.amazon_linux_2023.id                 # Use the latest Amazon Linux 2023 AMI
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

resource "aws_iam_role" "ec2_handson_role" {
  name = "ec2_handson_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_iam_read_only" {

  role       = aws_iam_role.ec2_handson_role.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_handson_profile" {
  name = "ec2_handson_profile"
  role = aws_iam_role.ec2_handson_role.name
}