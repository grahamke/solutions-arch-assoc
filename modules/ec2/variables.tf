variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t2.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents
}

variable "ami" {
  type = string
}

variable "key_name" {
  type    = string
  default = null
}

variable "public_ip" {
  type    = bool
  default = true
}

variable "region" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = null
}