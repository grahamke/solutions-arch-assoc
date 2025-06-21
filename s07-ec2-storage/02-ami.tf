resource aws_instance base_instance {
  instance_type        = "t2.micro" # Set the instance type to a t2.micro instance
  ami                  = var.amazon_linux_2023_ami_id
  key_name             = module.ec2_key_pair.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [module.default_vpc_sg.sg_id]

  user_data = <<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
EOF

  tags = {
    Name = "Base Instance"
  }
}

output "base_instance_public_ip" {
  value = aws_instance.base_instance.public_ip
}

module "ec2_key_pair" {
  source = "../modules/key_pair"

  key_name        = "generated_key"
  filename        = "${path.module}/generated_key.pem"
  tags = {
    Name = "EC2 Key Pair"
  }
}

module default_vpc_sg {
  source = "../modules/default_vpc_sg"
}

# This will stop the base_instance to create a new AMI.
resource aws_ami_from_instance "base_ami" {
  name               = "base_ami"
  source_instance_id = aws_instance.base_instance.id
}

resource aws_instance private_ami_instance {
  instance_type        = "t2.micro" # Set the instance type to a t2.micro instance
  ami                  = aws_ami_from_instance.base_ami.id
  key_name             = module.ec2_key_pair.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [module.default_vpc_sg.sg_id]

  user_data = <<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "My New Private Instance"
  }
}

output "private_ami_instance_public_ip" {
  value = aws_instance.private_ami_instance.public_ip
}