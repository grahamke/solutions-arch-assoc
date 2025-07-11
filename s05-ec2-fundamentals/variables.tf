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

variable "budget_limit_amount" {
  description = "The amount of money in USD"
  default     = "10.0"
}

variable "budget_email_address" {
  description = "The email address to send the budget notifications to"
}

variable "amazon_linux_2023_ami_id" {
  description = "The AMI ID to use for the EC2 instances"
}