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

variable "vpc_name" {
  description = "The name of the VPC to create"
  default     = "DemoVPC"
}

variable "s3_flow_logs_bucket_name" {
  description = "The name of the S3 bucket to create for VPC Flow Logs"
}

variable "flow_logs_aggregation_interval" {
  description = "The interval in seconds at which VPC Flow Logs are aggregated"
  default     = 600
}