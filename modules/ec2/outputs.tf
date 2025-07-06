output "public_ip" {
  value       = aws_instance.instance.public_ip
  description = "The public IP address of the EC2 instance"
}

output "instance_id" {
  value       = aws_instance.instance.id
  description = "The instance ID of the EC2 instance"
}