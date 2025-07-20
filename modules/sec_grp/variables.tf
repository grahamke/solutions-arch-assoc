variable "region" {
  description = "Region where this resource will be managed."
  default     = null
}

variable "name" {
  description = "Name of the security group."
  default     = null
}

variable "ssh_cidr_block" {
  description = "The source IPv4 CIDR range for SSH access."
  default     = "0.0.0.0/0"
}

variable "vpc_id" {
  description = "VPC ID."
  default     = null
}