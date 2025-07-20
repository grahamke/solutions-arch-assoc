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

variable "ssh_cidr_block" {
  description = "The source IPv4 CIDR range for SSH access."
  default     = "0.0.0.0/0"
}

variable "budget_limit_amount" {
  description = "The amount of money in USD"
  default     = "10.0"
}

variable "budget_email_address" {
  description = "The email address to send the budget notifications to"
}