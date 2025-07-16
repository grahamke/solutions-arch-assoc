resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_sse
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "coffee" {
  bucket = aws_s3_bucket.demo.id
  source = "../resources/coffee.jpg"
  key    = "coffee.jpg"
  etag   = filemd5("../resources/coffee.jpg")

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.demo]
}

data "aws_kms_alias" "s3_kms" {
  name = "alias/aws/s3"
}

resource "aws_s3_object" "beach" {
  bucket = aws_s3_bucket.demo.id
  source = "../resources/beach.jpg"
  key    = "beach.jpg"

  depends_on = [aws_s3_bucket_server_side_encryption_configuration.demo]

  kms_key_id = data.aws_kms_alias.s3_kms.target_key_arn
}
