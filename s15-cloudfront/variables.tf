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

variable "bucket_name" {
  description = "The name of the S3 bucket to create to host website"
}

variable "us_east_1_ami" {
  description = "The AMI ID to use for the EC2 instance in us-east-1"
}

variable "ap_south_1_ami" {
  description = "The AMI ID to use for the EC2 instance in ap-south-1"
}