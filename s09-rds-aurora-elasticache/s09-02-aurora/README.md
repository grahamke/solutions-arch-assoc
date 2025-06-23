# Amazon Aurora MySQL

This directory contains Terraform configurations for Amazon Aurora MySQL covered in the Solutions Architect Associate course.

## Overview

The configuration demonstrates how to set up:
- Aurora MySQL cluster with reader instances
- Multi-AZ deployment for high availability
- Custom endpoints for workload separation
- Security groups and encryption

## Components

### 1. Aurora Cluster
- Aurora MySQL 8.x engine
- Primary and reader instances
- Multi-AZ deployment across availability zones
- Storage encryption with AWS KMS
- Automated backups

### 2. Instances
- Primary writer instance
- Reader instance in a different AZ
- Configurable instance class
- Public accessibility option

### 3. Endpoints
- Cluster endpoint (writer)
- Reader endpoint (load-balanced)
- Custom static endpoint for specific instances

### 4. Security
- VPC security group with restricted access
- Encrypted storage and connections
- Parameter groups for security settings

## Variables

| Name | Description | Default |
|------|-------------|---------|
| `region` | AWS region to deploy resources | - |
| `profile` | AWS CLI profile to use | - |
| `amazon_linux_2023_ami_id` | AMI ID for Amazon Linux 2023 | - |
| `aurora_mysql_version` | Aurora MySQL version to use | `"8.4"` |
| `mysql_username` | MySQL master username | `"admin"` |
| `mysql_password` | MySQL master password | - |
| `personal_ip_address` | Your IP address for security group access | - |
| `common_tags` | Map of common tags to apply to resources | `{ ManagedBy = "terraform" }` |

## Outputs

| Name | Description |
|------|-------------|
| `aurora_cluster_endpoint` | Writer endpoint for the Aurora cluster |
| `aurora_reader_endpoint` | Reader endpoint for the Aurora cluster |
| `aurora_cluster_instances` | Individual instance endpoints |
| `aurora_cluster_static_endpoint` | Static endpoint for the Aurora cluster |

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Connect to the writer endpoint:
   ```
   mysql -h $(terraform output -raw aurora_cluster_endpoint) -P 3306 -u admin -p
   ```

4. Connect to the reader endpoint:
   ```
   mysql -h $(terraform output -raw aurora_reader_endpoint) -P 3306 -u admin -p
   ```

5. Clean up:
   ```
   terraform destroy
   ```

## Important Notes

- The Aurora cluster takes approximately 10-15 minutes to provision
- The instances are publicly accessible but restricted to your IP address
- Aurora provides automatic failover between availability zones
- Remember to destroy the resources when done to avoid unnecessary charges