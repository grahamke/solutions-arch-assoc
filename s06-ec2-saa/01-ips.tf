resource "aws_instance" "instance" {
  instance_type               = "t2.micro" # Set the instance type to a t2.micro instance
  ami                         = var.amazon_linux_2023_ami_id
  associate_public_ip_address = true

  tags = {
    Name = "ips"
  }
}

output "instance_private_ip" {
  value = aws_instance.instance.private_ip
}

output "instance_public_ip" {
  value = aws_instance.instance.public_ip
}

resource "aws_eip" "eip" {
  instance = aws_instance.instance.id
}

output "eip_public_ip" {
  value = aws_eip.eip.public_ip
}
