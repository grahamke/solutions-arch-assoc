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

variable "aurora_mysql_version" {
  description = "The Aurora MySQL version to use for the RDS cluster"
  type        = string
  default     = "8.4"
}

variable "mysql_username" {
  description = "The MySQL master username to use for the RDS cluster"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "The MySQL master password to use for the RDS cluster"
  type        = string
}

variable personal_ip_address {
  description = "Your personal IP address"
  type        = string
}