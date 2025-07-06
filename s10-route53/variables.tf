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

variable "hosted_zone_id" {
  description = "The hosted zone ID to use"
  type        = string
}

variable "domain_name" {
  description = "Domain name to use (must match the domain in the domain-registration stack)"
  type        = string
  default     = "example-learning.com"
}

variable "eu_central_1_ami" {
  description = "The AMI ID to use for the EC2 instances in the EU Central 1 region"
}

variable "us_east_1_ami" {
  description = "The AMI ID to use for the EC2 instances in the US East 1 region"
}

variable "ap_southeast_1_ami" {
  description = "The AMI ID to use for the EC2 instances in the Southeast 1 region"
}