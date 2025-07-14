# S3 Security

This directory contains Terraform code for the S3 Security section of the AWS Solutions Architect Associate course.

## Overview

This section demonstrates S3 security features using Terraform, covering:

- Server-side encryption (SSE-S3 and SSE-KMS)
- Cross-Origin Resource Sharing (CORS) configuration
- S3 access logging
- Bucket policies and public access controls

## Demonstrated Resources

- S3 bucket with server-side encryption (AES256 and KMS)
- S3 objects with different encryption methods
- CORS configuration for cross-origin requests
- Access logging between S3 buckets
- Bucket policies for public website access
- Public access block configuration

## Skipped Resources

The following S3 security features were intentionally skipped:

### MFA Delete
- Requires root user access to enable/disable
- Cannot be managed through Terraform or IAM users

### Pre-signed URLs
- Must be generated at runtime using AWS SDK/CLI
- Terraform manages static infrastructure, not dynamic URLs

### Vault Lock / S3 Object Lock
- Would lock objects for minimum 24 hours
- Not suitable for temporary lab environments

### S3 Access Points
- Advanced feature for complex access patterns made simple
- No hands-on labs

### S3 Object Lambda
- Serverless compute feature for object transformation
- No hands-on labs

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (v1.12.0+)
- An AWS account with permissions to create S3 resources

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
5. Test CORS functionality by visiting the website URLs in outputs

## Important Notes

- Remember to destroy resources when done to avoid unnecessary charges:
  ```
  terraform destroy
  ```
- Access logs may take time to appear in the logging bucket
- CORS configuration allows cross-origin requests between the demo websites

## Variables

| Name                        | Description                           | Default |
|-----------------------------|---------------------------------------|---------|
| `region`                    | AWS region to deploy to               | -       |
| `profile`                   | AWS CLI profile to use                | -       |
| `bucket_sse`                | S3 bucket name for encryption demo    | -       |
| `bucket_origin_cors`        | S3 bucket name for CORS origin        | -       |
| `bucket_cors_other`         | S3 bucket name for CORS target        | -       |
| `access_logs_bucket_name`   | S3 bucket name for access logs        | -       |

## Outputs

| Name                 | Description                    |
|----------------------|--------------------------------|
| `origin_website_url` | URL of the CORS origin website |
| `other_website_url`  | URL of the CORS target website |