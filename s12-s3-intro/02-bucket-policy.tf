resource "aws_s3_bucket" "bucket_policy_demo" {
  bucket = var.bucket_policy
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.bucket_policy_demo.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy_demo" {
  bucket = aws_s3_bucket.bucket_policy_demo.id
  policy = data.aws_iam_policy_document.public_access_doc.json
}

data "aws_iam_policy_document" "public_access_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_policy_demo.arn}/*"]
  }
}

resource "aws_s3_object" "public_coffee" {
  bucket = aws_s3_bucket.bucket_policy_demo.bucket
  key    = "coffee.jpg"
  source = "../resources/coffee.jpg"
}