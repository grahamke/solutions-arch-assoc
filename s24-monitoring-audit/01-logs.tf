resource "aws_cloudwatch_log_group" "demo" {
  name              = "demo-log-group"
  retention_in_days = 0
}

resource "aws_cloudwatch_log_metric_filter" "demo" {
  name = "DemoFilter"
  pattern = "Installing"
  log_group_name = aws_cloudwatch_log_group.demo.name
  metric_transformation {
    name      = "DemoMetricFilter"
    namespace = "DemoMetricFilterNamespace"
    value     = "1"
  }
}