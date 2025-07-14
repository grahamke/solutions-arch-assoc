module origin_website {
  source = "../modules/s3-website"

  bucket_name = var.bucket_origin_cors
  index_file_name = "index.html"
  index_file_source = "../resources/index-with-fetch.html"
}

output "origin_website_url" {
  value = module.origin_website.website_endpoint
}

resource aws_s3_object coffee_pic {
  bucket = module.origin_website.bucket_id
  key = "coffee.jpg"
  source = "../resources/coffee.jpg"
  content_type = "image/jpeg"
  etag = filemd5("../resources/coffee.jpg")
}

module other_website {
  source = "../modules/s3-website"

  bucket_name = var.bucket_cors_other
  index_file_name = "index.html"
  index_file_source = "../resources/index.html"
}

resource aws_s3_object extra_page {
  bucket = module.other_website.bucket_id
  key = "extra-page.html"
  source = "../resources/extra-page.html"
  etag = filemd5("../resources/extra-page.html")
}

output "other_website_url" {
  value = module.other_website.website_endpoint
}

resource aws_s3_bucket_cors_configuration other_cors {
  bucket = module.other_website.bucket_id
  cors_rule {
    allowed_headers = ["Authorization"]
    allowed_methods = ["GET"]
    allowed_origins = ["http://${module.origin_website.website_endpoint}"]
    expose_headers = []
    max_age_seconds = 3000
  }
}