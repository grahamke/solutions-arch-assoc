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

variable "budget_limit_amount" {
  type        = string
  description = "The amount of cost or usage being measured for a budget."
  default     = "10.0"
}

variable "budget_limit_unit" {
  type        = string
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB."
  default     = "USD"
}

variable "budget_email_address" {
  type        = string
  description = "E-Mail addresses to notify."
}