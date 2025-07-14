resource "aws_s3_bucket" "website" {
  bucket = var.bucket_website
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_demo" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_doc.json

  depends_on = [aws_s3_bucket_public_access_block.website]
}

data "aws_iam_policy_document" "website_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website.id
  key          = "index.html"
  source       = "../resources/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "website_beach" {
  bucket       = aws_s3_bucket.website.id
  key          = "beach.jpg"
  source       = "../resources/beach.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "website_coffee" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "coffee.jpg"
  source       = "../resources/coffee.jpg"
  content_type = "image/jpeg"
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}