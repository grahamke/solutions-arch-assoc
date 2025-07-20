# Amazon RDS MySQL

This directory contains Terraform configurations for Amazon RDS MySQL covered in the Solutions Architect Associate course.

## Overview

The configuration demonstrates how to set up:
- Amazon RDS MySQL database instance
- Parameter groups and option groups
- Security groups for database access
- Subnet groups for VPC placement

## Components

### 1. RDS MySQL Instance
- Single instance deployment
- MySQL 8.4 engine
- Configurable instance class
- Storage encryption with AWS KMS
- Automated backups

### 2. Networking
- Placement in default VPC
- Security group with restricted access
- Public accessibility option

### 3. Parameters and Options
- Default parameter group
- Default option group
- Configurable settings

Run the following to get your system's public IP address:
   ```
   curl checkip.amazonaws.com
   ```

## Variables

| Name                       | Description                               | Default                       |
|----------------------------|-------------------------------------------|-------------------------------|
| `region`                   | AWS region to deploy resources            | -                             |
| `profile`                  | AWS CLI profile to use                    | -                             |
| `common_tags`              | Map of common tags to apply to resources  | `{ ManagedBy = "terraform" }` |
| `mysql_version`            | MySQL version to use                      | `"8.4"`                       |
| `mysql_username`           | MySQL master username                     | `"admin"`                     |
| `mysql_password`           | MySQL master password                     | -                             |
| `personal_ip_address`      | Your IP address for security group access | -                             |

## Sample terraform.tfvars

```hcl
region  = "us-west-2"
profile = "default"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
   Section     = "RDS + Aurora + ElastiCache Hands On"
}
mysql_version  = "8.4"
mysql_password = "password"
personal_ip_address = "33.44.55.66"
```

## Outputs

| Name | Description |
|------|-------------|
| `mysql_hostname` | Hostname for connecting to the RDS instance |
| `mysql_port` | Port for connecting to the RDS instance |
| `mysql_username` | Username for connecting to the RDS instance |

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Connect to the database:
   ```
   mysql -h $(terraform output -raw mysql_hostname) -P $(terraform output -raw mysql_port) -u $(terraform output -raw mysql_username) -p
   ```

4. Clean up:
   ```
   terraform destroy
   ```

## Important Notes

- The RDS instance takes approximately 5-10 minutes to provision
- The instance is publicly accessible but restricted to your IP address
- Remember to destroy the resources when done to avoid unnecessary charges