# EC2 Fundamentals

This directory contains Terraform code for the EC2 Fundamentals section of the AWS Solutions Architect Associate course.

## Overview

This section demonstrates how to provision and configure EC2 instances using Terraform, covering:

- EC2 instance creation with Amazon Linux 2023 (AMI looked up via SSM)
- Basic Security group configuration
- SSH key pair generation and local storage
- User data for EC2 instance bootstrapping
- IAM role and instance profile setup
- Budget alerts for cost management

## Demonstrated Resources

- EC2 instance with Apache web server
- Security group with SSH and HTTP access
- SSH key pair (generated and saved locally as .pem file)
- Necessary default VPC configuration
- IAM role and instance profile for EC2
- AWS Budget for cost monitoring
- SSM parameter lookup for latest Amazon Linux 2023 AMI
- Spot instance configuration

## Skipped Resources

### Reserved Instance
  - Requires `offering_id` from AWS Console or API
### Savings Plan
  - This is done in the AWS Console
### Dedicated Host
  - Requires provisioning an `aws_ec2_host` and using the `aws_ec2_host.id` on the `aws_instance.host_id` property
  - Cost savings use the aws_ec2_host_reservation 
### Capacity Reservation
- Uses `aws_ec2_capacity_reservation` and specify the `id` in an `aws_instance.capacity_reservation_target.capacity_reservation_id`
- `aws_ec2_capacity_reservation_fleet` can be used for Capacity Reservation Groups

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (v1.12.0+)
- An AWS account with permissions to create the resources

## Usage

1. Review and update `terraform.tfvars` with your settings
2. Initialize Terraform:
   ```
   terraform init
   ```
3. Plan the deployment:
   ```
   terraform plan -out tfplan
   ```
4. Review the plan and apply the configuration:
   ```
   terraform apply tfplan
   ```
5. Access your EC2 instance using the generated key:
   ```
   ssh -i generated_key.pem ec2-user@<instance-ip>
   ```
   (The key filename is also available as a Terraform output)

## Important Notes

- The budget configuration is duplicated in the standalone `budget-limit` directory
- Remember to destroy resources when done to avoid unnecessary charges:
  ```
  terraform destroy
  ```
- The AMI ID is automatically looked up via SSM parameter for the latest Amazon Linux 2023
- Both regular and spot instances are created for comparison

## Variables

| Name                   | Description                    | Default                     |
|------------------------|--------------------------------|-----------------------------|
| `region`               | AWS region to deploy to        | -                           |
| `profile`              | AWS CLI profile to use         | -                           |
| `common_tags`          | Common tags for all resources  | `{ManagedBy = "terraform"}` |
| `budget_limit_amount`  | Budget amount in USD           | "10.0"                      |
| `budget_email_address` | Email for budget notifications | -                           |


## Sample terraform.tfvars

```hcl
region  = "us-west-2"
profile = "default"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
  Section     = "EC2 Fundamentals Hands On"
}
ssh_cidr_block       = "33.44.55.66/32"
budget_limit_amount  = "10.0"
budget_email_address = "your.email@example.com"
```

## Outputs

| Output Name         | Description                                |
|---------------------|--------------------------------------------|
| `first_instance_ip` | Public IP address of the main EC2 instance |
| `spot_instance_ip`  | Public IP address of the spot instance     |
| `identity_filename` | Path to the generated SSH private key file |