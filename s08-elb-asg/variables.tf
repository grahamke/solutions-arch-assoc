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

variable "amazon_linux_2023_ami_id" {
  description = "The AMI ID to use for the EC2 instances"
}

variable "alb_instances" {
  description = "The number of instances to run in the ALB ASG"
  default     = 2
}