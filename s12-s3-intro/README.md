# S3 Introduction - Terraform Examples

This directory contains Terraform configurations demonstrating various Amazon S3 features and concepts covered in the AWS Solutions Architect Associate course.

## 📁 Files Overview

- **[01-s3.tf](01-s3.tf)** - Basic S3 bucket creation and object uploads
- **[02-bucket-policy.tf](02-bucket-policy.tf)** - S3 bucket policies for public access
- **[03-website.tf](03-website.tf)** - Static website hosting with S3
- **[04-versioning.tf](04-versioning.tf)** - S3 object versioning demonstration
- **[05-replication.tf](05-replication.tf)** - Cross-region replication setup
- **[06-storage-classes.tf](06-storage-classes.tf)** - Storage classes and lifecycle policies
- **[provider.tf](provider.tf)** - AWS provider configuration
- **[variables.tf](variables.tf)** - Variable definitions
- **[terraform.tfvars](terraform.tfvars)** - Variable values

## 🎯 Learning Objectives

This configuration demonstrates:

- **Basic S3 Operations**: Bucket creation and object management
- **Security**: Bucket policies and public access controls
- **Static Website Hosting**: Configuring S3 for web hosting
- **Versioning**: Object version management and lifecycle
- **Cross-Region Replication**: Automated data replication across regions
- **Storage Classes**: Cost optimization through storage tiers
- **Lifecycle Policies**: Automated object transitions

## 🚀 Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **Clean up resources**:
   
   ⚠️ **Important**: Before running `terraform destroy`, you must empty the replica bucket as it contains replicated objects that Terraform cannot automatically delete.
   
   ```bash
   # Empty the replica bucket first
   aws s3 rm s3://your-replica-bucket-name --recursive
   
   # Then destroy the infrastructure
   terraform destroy
   ```
   
   Replace `your-replica-bucket-name` with the actual name from your `bucket_destination` variable.

## 📋 Resources Created

- **S3 Buckets**: Multiple buckets for different demonstrations
- **S3 Objects**: Sample files (coffee.jpg, beach.jpg, HTML files)
- **Bucket Policies**: Public access policies for website hosting
- **IAM Role**: For cross-region replication
- **Lifecycle Configuration**: Automated storage class transitions
- **Website Configuration**: Static website hosting setup

## 🔧 Configuration Details

### Bucket Names
All bucket names are configured via variables in `terraform.tfvars`:
- Basic demo bucket
- Bucket policy demo
- Website hosting bucket
- Versioning demo bucket
- Replication origin/destination buckets
- Storage classes demo bucket

### Cross-Region Replication
- **Origin Region**: us-east-2
- **Destination Region**: us-east-1
- **Features**: Delete marker replication enabled

### Storage Classes Demonstrated
- **STANDARD** (default)
- **STANDARD_IA** (Infrequent Access)
- **INTELLIGENT_TIERING**
- **GLACIER_IR** (Instant Retrieval)

## Variables

| Name                     | Description                                           | Default |
|--------------------------|-------------------------------------------------------|---------|
| `region`                 | AWS region to deploy resources                        | -       |
| `profile`                | AWS CLI profile to use                               | -       |
| `common_tags`            | Common tags to apply to all resources                | -       |
| `bucket_basic`              | Name of the basic S3 bucket                          | -       |
| `bucket_policy`              | Name of the bucket policy demo bucket                | -       |
| `bucket_website`         | Name of the static website hosting bucket            | -       |
| `bucket_versioning`      | Name of the versioning demo bucket                   | -       |
| `bucket_origin`          | Name of the replication origin bucket                | -       |
| `bucket_destination`     | Name of the replication destination bucket           | -       |
| `replication_region`     | AWS region for replication destination               | -       |
| `bucket_storage_classes` | Name of the storage classes demo bucket              | -       |

## ⚠️ Important Notes

- **Cost Awareness**: This creates multiple S3 buckets and objects - remember to destroy when done
- **Public Access**: Some buckets are configured for public access for demonstration purposes
- **Cross-Region Charges**: Replication incurs data transfer costs between regions
- **Unique Naming**: S3 bucket names must be globally unique - update variables accordingly
- **Replica Bucket Cleanup**: The replica bucket must be manually emptied before `terraform destroy` can complete successfully

## 🔗 Related AWS Services

- **Amazon S3**: Object storage service
- **IAM**: Identity and Access Management for replication roles
- **CloudFront**: Can be used with S3 for content delivery (not included)

---

**Remember**: Always run `terraform destroy` when finished to avoid ongoing charges!