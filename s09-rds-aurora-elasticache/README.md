# RDS, Aurora, and ElastiCache

This directory contains Terraform configurations for AWS database services covered in the Solutions Architect Associate course.

## Directory Structure Change

**Note:** Unlike previous sections, this section uses subdirectories for each database service:

```
s09-rds-aurora-elasticache/
├── s09-01-rds/         # Amazon RDS MySQL configuration
├── s09-02-aurora/      # Amazon Aurora MySQL configuration
└── s09-03-elasticache/ # Amazon ElastiCache Redis configuration
```

This structure was chosen because:

1. **Resource Provisioning Time**: Each database service takes several minutes to provision and destroy
2. **Independent Testing**: Allows working with one service at a time without affecting others
4. **Clearer Organization**: Separates configurations for different database technologies

## Services Covered

### Amazon RDS (s09-01-rds)
- Standard MySQL database instance
- Parameter groups and option groups
- Multi-AZ deployment options
- Storage configuration and encryption

### Amazon Aurora (s09-02-aurora)
- Aurora MySQL cluster with reader instances
- Custom endpoints
- Cluster parameter groups
- High availability configuration

### Amazon ElastiCache (s09-03-elasticache)
- Redis cache cluster
- Single-AZ configuration
- Security group setup
- Parameter groups
