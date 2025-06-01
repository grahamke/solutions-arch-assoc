resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16" # only one cidr block is associated on the aws_vpc resource. Use aws_vpc_ipv4_cidr_block_association to add more
  tags = merge(var.common_tags, {
    Name = var.vpc_name
  })

  # Added for IPv6
  assign_generated_ipv6_cidr_block = true
}
