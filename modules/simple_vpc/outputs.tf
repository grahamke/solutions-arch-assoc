output "vpc_id" {
  value = aws_vpc.vpc.id
}

output subnet_ids {
  value = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}