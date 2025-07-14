resource aws_s3_bucket_notification demo {
  bucket = aws_s3_bucket.bucket.id

  # this is it for EventBridge configuration
  eventbridge = true

  queue {
    id = "DemoEventNotification"
    queue_arn = aws_sqs_queue.queue.arn
    events = [
      "s3:ObjectCreated:*"
    ]
  }
}

data aws_iam_policy_document queue_resource_policy {
  version = "2012-10-17"
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.queue.arn]

    #
    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"
      values = [aws_s3_bucket.bucket.arn]
    }
  }
}

resource aws_sqs_queue_policy queue_resource_policy {
  queue_url = aws_sqs_queue.queue.id
  policy = data.aws_iam_policy_document.queue_resource_policy.json
}

resource aws_sqs_queue queue {
  name = "DemoS3Notification"
}

resource aws_s3_object coffee {
  bucket = aws_s3_bucket.bucket.id
  key = "coffee.jpg"
  source = "../resources/coffee.jpg"
  etag = filemd5("coffee.jpg")

  depends_on = [aws_s3_bucket_notification.demo]
}
