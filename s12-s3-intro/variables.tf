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