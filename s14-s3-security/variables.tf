variable "region" {
  type        = string
  description = "AWS Region where the provider will operate (e.g. us-east-1)"
}

variable "profile" {
  type        = string
  description = "AWS profile name as set in the shared configuration and credentials files."
}

variable "common_tags" {
  type        = map(string)
  description = "Configuration block with resource tag settings to apply across all resources handled by this provider."
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