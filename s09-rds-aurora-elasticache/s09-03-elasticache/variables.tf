variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  type        = string
}

variable "profile" {
  description = "The AWS profile to use"
  type        = string
}

variable "common_tags" {
  type = map(string)
  default = {
    ManagedBy = "terraform"
  }
}