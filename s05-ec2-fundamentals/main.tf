terraform {
  required_version = ">= 1.12.0" # Ensure that the Terraform version is 1.0.0 or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source of the AWS provider
      version = ">= 5.98.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  default_tags {
    tags = merge(
      {
        Environment = "Development"
        Project     = "SAA-C03"
        CostCenter  = "education"
        ManagedBy   = "Terraform"
        Owner       = "Kevin Graham"
      },
    var.common_tags)
  }
}
