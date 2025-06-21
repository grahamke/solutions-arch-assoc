# EC2 Storage Solutions

This directory contains Terraform configurations for AWS EC2 storage solutions covered in the Solutions Architect Associate course.

## Components

### 1. EBS (Elastic Block Store)
- Volume creation and attachment
- Snapshot management
- Snapshot archiving and restoration
- Recycle bin rules for snapshots

### 2. AMI (Amazon Machine Images)
- Creating custom AMIs from EC2 instances
- Launching instances from custom AMIs

### 3. EFS (Elastic File System)
- Creating encrypted EFS file systems
- Setting up mount targets across availability zones
- Configuring lifecycle policies for IA and Archive storage tiers
- Enabling automatic backups
- Mounting EFS on EC2 instances in different AZs

## Architecture

The configuration creates:
- EC2 instances in different availability zones
- An EFS file system with mount targets in multiple subnets
- Security groups with proper rules for NFS traffic
- Automatic mounting of EFS on instance boot

## Security Features

- Encrypted EFS using AWS managed KMS key
- Security groups with least privilege access
- TLS for EFS mounts

## Cost Optimization

- Lifecycle policies to transition infrequently accessed data to cheaper storage tiers
- Automatic transition back to standard storage upon access

## Variables

| Name                       | Description                              | Default |
|----------------------------|------------------------------------------|---------|
| `region`                   | AWS region to deploy resources           | -       |
| `profile`                  | AWS CLI profile to use                   | -       |
| `amazon_linux_2023_ami_id` | AMI ID for Amazon Linux 2023             | -       |
| `common_tags`              | Map of common tags to apply to resources | -       |

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Connect to instances:
   ```
   ssh -i generated_key.pem ec2-user@<instance_ip>
   ```

4. Test EFS shared storage:
   - Create files on one instance in `/mnt/efs/fs1`
   - Verify files are accessible from the other instance

5. Clean up:
   ```
   terraform destroy
   ```