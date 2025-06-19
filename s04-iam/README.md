# AWS IAM Management with Terraform

This module is part of the AWS Solutions Architect Associate preparation project. It demonstrates AWS Identity and Access Management (IAM) best practices using Terraform.

## Overview

This module creates and manages:
- IAM users and groups
- IAM policies and attachments
- Password policies
- MFA devices
- IAM roles for EC2 service

## Components

### 1. IAM User and Group Management (`01-iam.tf`)

- Creates an IAM user with a secure, auto-generated password
- Sets up an admin group with AdministratorAccess policy
- Adds the user to the admin group
- Configures account alias for easier console login (commented out by default)

### 2. IAM Policies and Groups (`02-iam-policies.tf`)

- Demonstrates attaching policies directly to users (IAMReadOnlyAccess)
- Creates a "Developers" group with specific permissions
- Shows how to attach AWS managed policies to groups

### 3. Password Policy (`03-password-policy.tf`)

- Implements a strong password policy for the AWS account
- Enforces minimum length, complexity requirements, and password reuse prevention

### 4. Multi-Factor Authentication (`04-mfa.tf`)

- Creates a virtual MFA device for the IAM user
- Includes instructions for importing an existing MFA device into Terraform state

### 5. IAM Roles (`05-iam-roles.tf`)

- Creates an IAM role for EC2 instances
- Demonstrates how to define trust relationships with assume role policies
- Attaches IAM read-only permissions to the role

## Usage

1. Configure your AWS credentials and region in `terraform.tfvars`:

```hcl
region = "us-east-1"
profile = "your-profile"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
}
iam_user_name = "saac03"
```

2. Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```


## Notes

- The account alias in `01-iam.tf` is commented out by default
- User passwords are generated automatically and output as sensitive values
- This module demonstrates core IAM concepts for the AWS Solutions Architect Associate exam