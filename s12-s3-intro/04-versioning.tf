resource "aws_s3_bucket" "versioning" {
  bucket = var.bucket_versioning
}

data "aws_iam_policy_document" "versioning_doc" {
  statement {
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.versioning.arn}/*"]
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.versioning.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "versioning_index" {
  bucket       = aws_s3_bucket.versioning.bucket
  key          = "index.html"
  source       = "../resources/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "versioning_beach" {
  bucket       = aws_s3_bucket.versioning.bucket
  key          = "beach.jpg"
  source       = "../resources/beach.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "versioning_coffee" {
  bucket       = aws_s3_bucket.versioning.bucket
  key          = "coffee.jpg"
  source       = "../resources/coffee.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "overwrite_index" {
  bucket       = aws_s3_bucket_versioning.versioning.bucket
  key          = "index.html"
  source       = "../resources/really_index.html"
  content_type = "text/html"

  depends_on = [aws_s3_object.index]
}


resource "aws_s3_bucket_website_configuration" "versioning_website" {
  bucket = aws_s3_bucket.versioning.id

  index_document {
    suffix = "index.html"
  }
}