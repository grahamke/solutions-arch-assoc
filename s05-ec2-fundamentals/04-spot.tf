resource "aws_instance" "spot_instance" {
  instance_type = "t2.micro"
  ami           = data.aws_ssm_parameter.al2023_ami.insecure_value
  key_name      = aws_key_pair.ec2_key.key_name

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      max_price                      = "0.005" # Try higher and lower prices
      spot_instance_type             = "persistent"
    }
  }

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.launch_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_hands_on_profile.name

  user_data = <<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF

  tags = {
    Name = "My First Spot Instance"
  }
}

output "spot_instance_ip" {
  value = aws_instance.spot_instance.public_ip
}