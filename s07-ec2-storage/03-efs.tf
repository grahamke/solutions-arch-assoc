data "aws_kms_key" "efs_key" {
  key_id = "alias/aws/elasticfilesystem"
}

resource "aws_efs_file_system" "demo" {

  encrypted        = true
  kms_key_id       = data.aws_kms_key.efs_key.arn
  throughput_mode  = "elastic"
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  lifecycle_policy {
    transition_to_archive = "AFTER_90_DAYS"
  }
  lifecycle_policy {
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
}

resource "aws_efs_backup_policy" "policy" {
  file_system_id = aws_efs_file_system.demo.id

  backup_policy {
    status = "ENABLED"
  }
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

resource "aws_efs_mount_target" "mount_target" {
  count = length(data.aws_subnets.default.ids)

  file_system_id  = aws_efs_file_system.demo.id
  subnet_id       = data.aws_subnets.default.ids[count.index]
  security_groups = [aws_security_group.efs_security_group.id]
}

resource "aws_security_group" "efs_security_group" {
  name        = "efs-demo"
  description = "EFS Demo SG"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "efs_in" {
  security_group_id            = aws_security_group.efs_security_group.id
  from_port                    = 2049
  to_port                      = 2049
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.default_vpc_sg.sg_id
}

resource "aws_vpc_security_group_egress_rule" "ec2_out_to_efs" {
  security_group_id            = module.default_vpc_sg.sg_id
  from_port                    = 2049
  to_port                      = 2049
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.efs_security_group.id
}

resource "aws_vpc_security_group_egress_rule" "efs_out" {
  security_group_id = aws_security_group.efs_security_group.id
  from_port         = -1
  to_port           = -1
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "instance_a" {
  instance_type     = "t2.micro" # Set the instance type to a t2.micro instance
  ami               = data.aws_ssm_parameter.al2023_ami.insecure_value
  key_name          = module.ec2_key_pair.key_name
  availability_zone = "${var.region}a"
  subnet_id         = local.az_a_subnet_id

  vpc_security_group_ids = [module.default_vpc_sg.sg_id]

  user_data = <<-EOF
    #!/bin/bash
    # Install EFS utilities
    yum install -y amazon-efs-utils

    # Create mount directory
    mkdir -p /mnt/efs/fs1

    # Add EFS mount to fstab for automatic mounting on reboot
    echo "${aws_efs_file_system.demo.id}:/ /mnt/efs efs _netdev,tls,iam 0 0" >> /etc/fstab

    # Mount EFS
    mount -t efs -o tls ${aws_efs_file_system.demo.id}:/ /mnt/efs/fs1

    # Set permissions
    chmod 777 /mnt/efs/fs1
  EOF

  tags = {
    Name = "Instance A with EFS"
  }
}

output "instance_a_public_ip" {
  value = aws_instance.instance_a.public_ip
}

resource "aws_instance" "instance_b" {
  instance_type     = "t2.micro"
  ami               = data.aws_ssm_parameter.al2023_ami.insecure_value
  key_name          = module.ec2_key_pair.key_name
  availability_zone = "${var.region}b"
  subnet_id         = local.az_b_subnet_id

  vpc_security_group_ids = [module.default_vpc_sg.sg_id]

  user_data = <<-EOF
    #!/bin/bash
    # Install EFS utilities
    yum install -y amazon-efs-utils

    # Create mount directory
    mkdir -p /mnt/efs/fs1

    # Add EFS mount to fstab for automatic mounting on reboot
    echo "${aws_efs_file_system.demo.id}:/ /mnt/efs efs _netdev,tls,iam 0 0" >> /etc/fstab

    # Mount EFS
    mount -t efs -o tls ${aws_efs_file_system.demo.id}:/ /mnt/efs/fs1

    # Set permissions
    chmod 777 /mnt/efs/fs1
  EOF

  tags = {
    Name = "Instance B with EFS"
  }
}

output "instance_b_public_ip" {
  value = aws_instance.instance_b.public_ip
}

# Get details of all subnets
data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

locals {
  az_a_subnet_id = [
    for subnet_id, subnet in data.aws_subnet.all : subnet.id
    if subnet.availability_zone == "${var.region}a"
  ][0]

  az_b_subnet_id = [
    for subnet_id, subnet in data.aws_subnet.all : subnet.id
    if subnet.availability_zone == "${var.region}b"
  ][0]
}