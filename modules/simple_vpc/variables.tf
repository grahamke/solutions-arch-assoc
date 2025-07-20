variable "region" {
  description = "Region where this resource will be managed."
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

variable "enable_dns_support" {
  description = "Enables DNS support in this VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enables DNS hostnames in this VPC"
  default     = false
}