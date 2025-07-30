resource "aws_cloudwatch_log_group" "tail_demo" {
  name              = "DemoLogGroup"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_stream" "tail_demo" {
  name = "DemoLogStream"
  log_group_name = aws_cloudwatch_log_group.demo.name
}

