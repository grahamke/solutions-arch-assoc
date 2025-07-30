module "ec2_instance" {
  source = "../modules/ec2"
  ami = data.aws_ssm_parameter.al2023_ami.insecure_value
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_cloudwatch_metric_alarm" "demo" {
  alarm_name          = "TerminateEC2OnHighCPU"
  namespace = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic = "Average"
  period = 300
  comparison_operator = "GreaterThanThreshold"
  threshold = 95
  datapoints_to_alarm = 3
  evaluation_periods  = 3
  treat_missing_data = "missing"
  alarm_actions = ["arn:aws:automate:${var.region}:ec2:terminate"]
  dimensions = {
    InstanceId = module.ec2_instance.instance_id
  }
}