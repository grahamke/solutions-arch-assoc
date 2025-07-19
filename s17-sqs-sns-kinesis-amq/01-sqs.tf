resource "aws_sqs_queue" "demo" {
  name                       = "DemoQueue"
  visibility_timeout_seconds = 30
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  message_retention_seconds  = 345600
  max_message_size           = 262144

  sqs_managed_sse_enabled = true
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "demo_sqs_queue_policy_doc" {
  version = "2012-10-17"
  statement {
    sid    = "owner"
    effect = "Allow"
    principals {
      identifiers = [data.aws_caller_identity.current.arn]
      type        = "AWS"
    }
    actions = [
      "sqs:*"
    ]
    resources = [aws_sqs_queue.demo.arn]
  }
}

resource "aws_sqs_queue_policy" "demo" {
  queue_url = aws_sqs_queue.demo.url
  policy    = data.aws_iam_policy_document.demo_sqs_queue_policy_doc.json
}
