# EC2 Solutions Architect Associate Level

This directory contains Terraform code for the EC2 Solutions Architect Associate level section of the AWS Solutions Architect Associate course.

## Overview

This section builds on the EC2 Fundamentals and demonstrates advanced EC2 features and configurations using Terraform, including:

- Elastic IP addresses and IP management
- Placement groups (cluster, spread, partition)
- Elastic Network Interfaces (ENIs)
- EC2 hibernation

## Resources Created

- Elastic IP addresses
- Placement groups with different strategies
- Elastic Network Interfaces
- Hibernation-enabled EC2 instance
- SSH key pair (using a reusable module)

## Advanced Features Demonstrated

- **IP Management**: Elastic IPs for static public IP addresses
- **Placement Groups**: 
  - Cluster: For high-performance computing
  - Spread: For critical applications requiring isolation
  - Partition: For large distributed workloads
- **ENIs**: Additional network interfaces for multi-homed instances
- **Hibernation**: Preserving RAM state between instance stops


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
4. Apply the configuration:
   ```
   terraform apply tfplan
   ```

## Important Notes

- Remember to destroy resources when done to avoid unnecessary charges:
  ```
  terraform destroy
  ```
- The AMI ID is specified in terraform variables. Specify your own `terraform.tfvars`.
- Some placement group strategies require specific instance types (not t2.micro)

## Variables

| Name                       | Description                       | Default          |
|----------------------------|-----------------------------------|------------------|
| `region`                   | AWS region to deploy to           | -                |
| `profile`                  | AWS CLI profile to use            | -                |
| `amazon_linux_2023_ami_id` | AMI ID for Amazon Linux 2023      | -                |
| `common_tags`              | Map of tags to apply to resources | Various defaults |