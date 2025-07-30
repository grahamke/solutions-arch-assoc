resource "aws_cloudwatch_event_bus" "demo" {
  name = "central-event-bus"
}

resource "aws_cloudwatch_event_archive" "demo" {
  event_source_arn = aws_cloudwatch_event_bus.demo.arn
  name             = "central-event-bus-archive"
}

resource "aws_schemas_discoverer" "demo" {
  source_arn = aws_cloudwatch_event_bus.demo.arn
}

resource "aws_cloudwatch_event_rule" "demo" {
  name = "DemoRuleEventBridge"
  event_bus_name = data.aws_cloudwatch_event_bus.default.name

  event_pattern = jsonencode({
    source = ["aws.ec2"]
    detail-type = ["EC2 Instance State-change Notification"]
    detail = {
      state = ["stopped", "terminated"]
    }
  })
}

resource "aws_cloudwatch_event_target" "demo" {
  arn  = aws_sns_topic.demo_topic.arn
  rule = aws_cloudwatch_event_rule.demo.name
}

resource "aws_sns_topic" "demo_topic" {
  name = "demo-topic"
}

resource "aws_sns_topic_policy" "event_bridge_to_sns" {
  arn    = aws_sns_topic.demo_topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect = "Allow"
    actions = ["SNS:Publish"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type = "Service"
    }
    resources = [aws_sns_topic.demo_topic.arn]
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  endpoint  = var.sns_subscription_email_address
  protocol  = "email"
  topic_arn = aws_sns_topic.demo_topic.arn
}

data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}