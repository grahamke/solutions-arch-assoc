variable "region" {
  description = "The AWS region to deploy to (e.g. us-east-1)"
}

variable "profile" {
  description = "The AWS profile to use"
}

variable "common_tags" {
  type = map(string)
  default = {
    ManagedBy = "terraform"
  }
}

variable "vpc_name" {
  description = "The name of the VPC to create"
  default     = "DemoVPC"
}

variable "amazon_linux_2023_ami_id" {
  description = "The AMI ID to use for the EC2 instances"
  default     = "ami-06c8f2ec674c67112"
}

variable my_ip_address {
  description = "Your IP Address. Used for Security Group ingress"
}

variable s3_flow_logs_bucket_name {
  description = "The name of the S3 bucket to create for VPC Flow Logs"
}

variable flow_logs_aggregation_interval {
  description = "The interval in seconds at which VPC Flow Logs are aggregated"
  default     = 600
}