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

variable "sns_subscription_email_address" {
  type = string
  description = "The email address to subscribe to SNS messages"
}

variable "firehose_bucket_name" {
  type = string
  description = "The name of the Amazon Data Firehose destination bucket"
}