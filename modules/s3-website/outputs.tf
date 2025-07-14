output "bucket_id" {
  value = aws_s3_bucket.website.id
  description = "The ID of the bucket used for the website"
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}