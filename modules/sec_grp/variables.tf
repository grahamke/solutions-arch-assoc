variable "region" {
  description = "AWS region"
  default     = null
}

variable "name" {
  description = "Name of the security group"
  default     = null
}

variable "ssh_cidr_block" {
  description = "CIDR block for SSH access"
  default     = "0.0.0.0/0"
}

variable "vpc_id" {
  description = "VPC ID"
  default     = null
}