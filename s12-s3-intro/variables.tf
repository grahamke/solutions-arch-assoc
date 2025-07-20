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

variable "bucket_basic" {
  description = "The name of the S3 bucket to use for the most basic example"
}

variable "bucket_policy" {
  description = "The name of the S3 bucket to use for the bucket policy example"
}

variable "bucket_website" {
  description = "The name of the S3 bucket to use for a public website"
}

variable "bucket_versioning" {
  description = "The name of the S3 bucket to use for the bucket versioning example"
}

variable "bucket_origin" {
  description = "The name of the origin S3 bucket to use for the replication example"
}

variable "bucket_destination" {
  description = "The name of the destination S3 bucket to use for the replication example"
}

variable "replication_region" {
  description = "The AWS region to deploy the replicated S3 bucket to (e.g. us-west-2)"
}

variable "bucket_storage_classes" {
  description = "The name of the S3 bucket to use for the storage classes example"
}