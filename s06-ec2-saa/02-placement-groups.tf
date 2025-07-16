resource "aws_placement_group" "high_perf" {
  name     = "my-high-performance-group"
  strategy = "cluster"
}

resource "aws_placement_group" "distro" {
  name     = "my-distributed-group"
  strategy = "partition"
}

resource "aws_placement_group" "critical" {
  name     = "my-critical-group"
  strategy = "spread"
}

resource "aws_instance" "critical_server" {
  ami             = var.amazon_linux_2023_ami_id
  instance_type   = "t2.micro"
  placement_group = aws_placement_group.critical.id
  tags = {
    Name = "critical_server"
  }
}