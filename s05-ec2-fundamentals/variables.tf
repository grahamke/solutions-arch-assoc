variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
  default     = "us-east-2"
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