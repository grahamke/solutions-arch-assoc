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

variable "bucket_name" {
  description = "The name of the S3 bucket to create to host website"
}