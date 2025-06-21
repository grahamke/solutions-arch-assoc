resource "aws_instance" "instance" {
  instance_type     = "t2.micro" # Set the instance type to a t2.micro instance
  ami               = var.amazon_linux_2023_ami_id
  availability_zone = "${var.region}a"

  tags = {
    Name = "My First Instance" # obviously not our first instance, but Stephane reused his
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = aws_instance.instance.availability_zone
  size              = 2
  encrypted         = true
  type              = "gp2" # defaults to gp2

  tags = {
    Name = "My First Volume"
  }
}

resource "aws_volume_attachment" "volume_attachment" {
  instance_id = aws_instance.instance.id
  volume_id   = aws_ebs_volume.volume.id
  device_name = "/dev/sdf" # This is the device name that the volume will be attached to
}

resource "aws_ebs_snapshot" "snapshot" {
  volume_id    = aws_ebs_volume.volume.id
  description  = "My first snapshot"
  storage_tier = "standard" # defaults to standard

  # storage_tier = "archive"
  tags = {
    Name = "My First Snapshot"
  }
}

data "aws_kms_key" "ebs_kms_key" {
  key_id = "alias/aws/ebs"
}

resource "aws_ebs_snapshot_copy" "snapshot_copy" {
  source_snapshot_id = aws_ebs_snapshot.snapshot.id
  source_region      = var.region
  description        = "My first snapshot copy"
  encrypted          = true
  kms_key_id         = data.aws_kms_key.ebs_kms_key.arn # if encrypted you need to specify the key. terraform will replace if not specified
  tags = {
    Name = "My First Snapshot Copy"
  }
}

resource "aws_ebs_volume" "volume_from_snapshot" {
  availability_zone = "${var.region}b"
  snapshot_id       = aws_ebs_snapshot_copy.snapshot_copy.id
  size              = aws_ebs_volume.volume.size
  encrypted         = true
  type              = aws_ebs_volume.volume.type

  tags = {
    Name = "My First Volume from Snapshot"
  }
}

resource "aws_rbin_rule" "recycle_bin_rule" {
  resource_type = "EBS_SNAPSHOT"

  retention_period {
    retention_period_value = 1
    retention_period_unit  = "DAYS"
  }

  tags = {
    "Name" = "DemoRetentionRule"
  }
}

