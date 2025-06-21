resource aws_instance some_server {
  count = 2
  ami = var.amazon_linux_2023_ami_id
  instance_type = "t2.micro"

  tags = {
    Name = "some_server_${count.index}"
  }
}

resource aws_network_interface eni {
  subnet_id = aws_instance.some_server[0].subnet_id
  # Update this attachment to use the second instance
  attachment {
    instance = aws_instance.some_server[0].id
    device_index = 1
  }

  tags = {
    Name = "DemoENI"
  }
}