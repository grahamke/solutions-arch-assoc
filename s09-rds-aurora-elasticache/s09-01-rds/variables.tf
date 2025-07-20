variable "region" {
  type        = string
  description = "AWS Region where the provider will operate (e.g. us-east-1)"
}

variable "profile" {
  type        = string
  description = "AWS profile name as set in the shared configuration and credentials files."
}

variable "common_tags" {
  type        = map(string)
  description = "Configuration block with resource tag settings to apply across all resources handled by this provider."
  default = {
    ManagedBy = "terraform"
  }
}

variable "mysql_version" {
  description = "The MySQL version to use for the RDS instance"
  type        = string
  default     = "8.4"
}

variable "mysql_username" {
  description = "The MySQL username to use for the RDS instance"
  type        = string
  default     = "admin"
}

variable "mysql_password" {
  description = "The MySQL password to use for the RDS instance"
  type        = string
}

variable "personal_ip_address" {
  description = "Your personal IP address"
  type        = string
}