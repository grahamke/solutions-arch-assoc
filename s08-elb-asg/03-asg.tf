resource "aws_autoscaling_group" "demo" {
  name = "DemoASG"

  launch_template {
    id      = aws_launch_template.demo.id
    version = aws_launch_template.demo.latest_version
  }

  vpc_zone_identifier = data.aws_subnets.default.ids

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]
  health_check_type = "ELB"

  min_size = 1
  max_size = 3
  # set desired capacity if not using autoscaling policy
  # desired_capacity = 1

  # This is a workaround to force ASG recreation.
  # depends_on = [aws_iam_service_linked_role.autoscaling]
}

resource "aws_launch_template" "demo" {
  name                   = "MyDemoTemplate"
  description            = "Template"
  image_id               = var.amazon_linux_2023_ami_id
  instance_type          = "t2.micro"
  key_name               = module.ec2_key_pair.key_name
  vpc_security_group_ids = [module.launch_sg.sg_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    # Use this for your user data (script from top to bottom)
    # install httpd (Linux 2 version)
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
EOF
  )
}

module "ec2_key_pair" {
  source = "../modules/key_pair"

  key_name = "generated_key"
  filename = "${path.module}/generated_key.pem"
  tags = {
    Name = "EC2 Key Pair"
  }
}

# This creates the necessary service-linked role that Auto Scaling needs to manage resources on your behalf,
# particularly for interacting with load balancers.
# If you already have an Auto Scaling service-linked role in your account, you can skip this step.
# resource "aws_iam_service_linked_role" "autoscaling" {
#   aws_service_name = "autoscaling.amazonaws.com"
#   description      = "Service-linked role for Auto Scaling"
# }

resource "aws_autoscaling_policy" "target_tracking_policy" {
  name                   = "DemoTargetTrackingPolicy"
  autoscaling_group_name = aws_autoscaling_group.demo.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}