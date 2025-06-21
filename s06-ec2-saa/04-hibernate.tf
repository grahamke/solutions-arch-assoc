resource aws_instance hibernate {
  ami = var.amazon_linux_2023_ami_id
  instance_type = "t2.micro"
  key_name = module.ec2_key_pair.key_name

  # Required for hibernation
  hibernation = true

  # Root volume must be encrypted for hibernation
  root_block_device {
    volume_type           = "gp2"
    volume_size = 8  # Must be large enough for RAM
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "hibernate"
  }
}

module "ec2_key_pair" {
  source = "../modules/key_pair"

  key_name        = "generated_key"
  filename        = "${path.module}/generated_key.pem"
  tags = {
    Name = "EC2 Key Pair"
  }
}
