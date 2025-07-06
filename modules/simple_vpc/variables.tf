variable "region" {
  description = "AWS region"
  default     = null
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  default     = "172.16.0.0/24"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "simple"
}