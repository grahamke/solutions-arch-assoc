output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "A list of the public subnet IDs."
  value       = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

output "private_subnet_ids" {
  description = "A list of the private subnet IDS."
  value       = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
}

output "public_route_table_id" {
  description = "The ID of the route table associated with the public subnets."
  value = aws_route_table.route_table.id
}