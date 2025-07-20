# Amazon ElastiCache Redis

This directory contains Terraform configurations for Amazon ElastiCache Redis covered in the Solutions Architect Associate course.

## Overview

The configuration demonstrates how to set up:
- ElastiCache Redis cluster in single-node mode
- Security groups for cache access
- Subnet groups for VPC placement
- Parameter groups for Redis configuration

## Components

### 1. ElastiCache Redis Cluster
- Single-node deployment (no replicas)
- Redis 7.1 engine
- Micro instance type for cost efficiency
- Single-AZ deployment
- No cluster mode

### 2. Networking
- Placement in default VPC
- Security group with restricted access
- Subnet group spanning multiple AZs

### 3. Parameters
- Default Redis parameter group
- Configurable Redis settings

## Variables

| Name          | Description                              | Default                       |
|---------------|------------------------------------------|-------------------------------|
| `region`      | AWS region to deploy resources           | -                             |
| `profile`     | AWS CLI profile to use                   | -                             |
| `common_tags` | Map of common tags to apply to resources | `{ ManagedBy = "terraform" }` |

## Outputs

| Name                   | Description                                  |
|------------------------|----------------------------------------------|
| `elasticache_endpoint` | Endpoint for connecting to the Redis cluster |
| `elasticache_port`     | Port for connecting to the Redis cluster     |

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Connect to the Redis cluster (from an EC2 instance in the same VPC):
   ```
   redis-cli -h $(terraform output -raw elasticache_endpoint) -p 6379
   ```

4. Clean up:
   ```
   terraform destroy
   ```

## Important Notes

- The ElastiCache cluster takes approximately 5-10 minutes to provision
- Redis is accessible only from within the VPC by default
- This configuration uses a single node without replication for simplicity
- For production use, consider enabling cluster mode and multi-AZ
- Remember to destroy the resources when done to avoid unnecessary charges