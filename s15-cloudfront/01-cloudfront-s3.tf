resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "website_beach" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "beach.jpg"
  source       = "../resources/beach.jpg"
  content_type = "image/jpeg"
  etag         = filemd5("../resources/beach.jpg")
}

resource "aws_s3_object" "website_coffee" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "coffee.jpg"
  source       = "../resources/coffee.jpg"
  content_type = "image/jpeg"
  etag         = filemd5("../resources/coffee.jpg")
}

resource "aws_s3_object" "website_index" {
  bucket       = aws_s3_bucket.bucket.id
  key          = "index.html"
  source       = "../resources/index.html"
  content_type = "text/html"
  etag         = filemd5("../resources/index.html")
}

locals {
  origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_cdn" {
  origin {
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.origin_id
  }
  enabled = true

  default_root_object = "index.html"


  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  default_cache_behavior {
    # Using the Managed-CachingOptimized policy ID:
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD"]
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "allow-all"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = aws_s3_bucket.bucket.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_iam_policy_document" "bucket_policy" {
  version = "2008-10-17"
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.s3_cdn.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}