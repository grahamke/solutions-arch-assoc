variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "profile" {
  description = "The AWS profile to use"
}

variable "common_tags" {
  type = map(string)
  default = {
    ManagedBy = "terraform"
  }
}

variable "bucket_sse" {
  description = "The name of the S3 bucket to use for the SSE example"
}

variable "bucket_origin_cors" {
  description = "The name of the S3 bucket to use for the CORS example"
}

variable "bucket_cors_other" {
  description = "The name of the 'other' S3 bucket to use for the CORS example"
}

variable "access_logs_bucket_name" {
  description = "The name of the S3 bucket to use to capture access logs of the bucket_sse bucket"
}