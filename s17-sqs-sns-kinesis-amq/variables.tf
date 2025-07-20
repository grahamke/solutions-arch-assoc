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

variable "sns_subscription_email_address" {
  type = string
  description = "The email address to subscribe to SNS messages"
}

variable "firehose_bucket_name" {
  type = string
  description = "The name of the Amazon Data Firehose destination bucket"
}