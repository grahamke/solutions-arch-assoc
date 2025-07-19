resource "aws_sns_topic" "demo" {
  name = "MyFirstTopic"
}

resource "aws_sns_topic_subscription" "demo" {
  endpoint  = var.sns_subscription_email_address
  protocol  = "email"
  topic_arn = aws_sns_topic.demo.arn
}