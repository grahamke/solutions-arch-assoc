resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_basic
}

resource "aws_s3_object" "coffee" {
  bucket = aws_s3_bucket.demo.bucket
  key    = "coffee.jpg"
  source = "coffee.jpg"
}

resource "aws_s3_object" "beach" {
  bucket = aws_s3_bucket.demo.bucket
  key    = "images/beach.jpg"
  source = "beach.jpg"
}