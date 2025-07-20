resource "aws_instance" "instance" {
  instance_type               = "t2.micro" # Set the instance type to a t2.micro instance
  ami                         = data.aws_ssm_parameter.al2023_ami.insecure_value
  associate_public_ip_address = true

  tags = {
    Name = "ips"
  }
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
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
