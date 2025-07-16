resource "aws_s3_bucket" "access_logs" {
  bucket = var.access_logs_bucket_name
}

resource "aws_s3_bucket_logging" "demo" {
  bucket        = aws_s3_bucket.demo.id
  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = ""
}

data "aws_iam_policy_document" "demo_write_access_logs_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "access_logging_policy" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.demo_write_access_logs_policy.json
}