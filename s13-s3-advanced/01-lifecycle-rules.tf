resource aws_s3_bucket bucket {
  bucket = var.bucket_name
}

resource aws_s3_bucket_lifecycle_configuration demo {
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "DemoRule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      storage_class = "STANDARD_IA"
      days = 30
    }

    transition {
      storage_class = "INTELLIGENT_TIERING"
      days = 60
    }

    transition {
      storage_class = "GLACIER_IR"
      days = 90
    }

    transition {
      storage_class = "GLACIER"
      days = 180
    }

    transition {
      storage_class = "DEEP_ARCHIVE"
      days = 365
    }

    noncurrent_version_transition {
      storage_class = "GLACIER"
      noncurrent_days = 90
    }

    expiration {
      days = 700
    }

    noncurrent_version_expiration {
      noncurrent_days = 700
    }
  }
}