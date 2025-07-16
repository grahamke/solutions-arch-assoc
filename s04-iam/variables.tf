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

variable "iam_user_name" {
  type        = string
  description = "The name of the IAM user to create"
}