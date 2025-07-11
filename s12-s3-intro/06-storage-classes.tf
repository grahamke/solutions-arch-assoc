resource "aws_s3_bucket" "storage_demo" {
  bucket = var.bucket_storage_classes
}

resource "aws_s3_object" "standard_ia_coffee" {
  bucket        = aws_s3_bucket.storage_demo.bucket
  key           = "coffee.jpg"
  source        = "coffee.jpg"
  storage_class = "STANDARD_IA"
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.storage_demo.bucket

  rule {
    id     = "DemoRule"
    status = "Enabled"
    filter {
      prefix = ""
    }
    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }
    transition {
      storage_class = "INTELLIGENT_TIERING"
      days          = 60
    }
    transition {
      storage_class = "GLACIER_IR"
      days          = 180
    }
  }
}