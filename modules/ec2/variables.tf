variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type to use for the instance."
}

variable "ami" {
  type        = string
  description = "AMI to use for the instance."
}

variable "key_name" {
  type        = string
  description = "Key name of the Key Pair to use for the instance."
  default     = null
}

variable "public_ip" {
  type        = bool
  description = "Whether to associate a public IP address with an instance in a VPC."
  default     = true
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed."
  default     = null
}

variable "user_data" {
  type        = string
  description = "User data to provide when launching the instance."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource."
  default     = {}
}

variable "subnet_id" {
  type        = string
  description = "VPC Subnet ID to launch in."
  default     = null
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with."
  default     = null
}