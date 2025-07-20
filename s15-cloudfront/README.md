# CloudFront & Global Accelerator

This directory contains Terraform code for the CloudFront & Global Accelerator section of the AWS Solutions Architect Associate course.

## Overview

This section demonstrates how to provision and configure CloudFront distributions and AWS Global Accelerator using Terraform, covering:

- CloudFront distribution with S3 origin
- CloudFront distribution with custom origin (EC2)
- Origin Access Control (OAC) for S3 security
- CloudFront behaviors and caching policies
- AWS Global Accelerator with multi-region endpoints
- Cross-region EC2 deployment for global acceleration

## Demonstrated Resources

- CloudFront distribution with S3 bucket origin
- CloudFront distribution with EC2 custom origin
- S3 bucket with Origin Access Control
- AWS Global Accelerator with TCP listener
- Multi-region EC2 instances (us-east-1, ap-south-1)
- VPCs and security groups in multiple regions
- Global Accelerator endpoint groups with health checks

## Topics Covered (Theory Only)

The following CloudFront topics were covered in the course but do not have hands-on labs:

- CloudFront with ALB/EC2 origin configuration
- CloudFront geo restrictions and geographic blocking
- CloudFront price classes and cost optimization
- CloudFront cache invalidation strategies

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
5. Test the CloudFront distribution and Global Accelerator endpoints
6. Remember to destroy resources when done:
   ```
   terraform destroy
   ```

## Important Notes

⚠️ **Setup and teardown will take significantly longer** due to:
- CloudFront distribution deployment (15-20 minutes)
- Global Accelerator provisioning (5-10 minutes)
- Multi-region resource creation
- CloudFront distribution deletion (15-20 minutes)

- Global Accelerator provides static IP addresses for global traffic routing
- CloudFront distributions can take 15-20 minutes to deploy and become available
- Resources are created in multiple AWS regions (us-east-1, ap-south-1)
- Remember to destroy resources when done to avoid unnecessary charges

## Variables

| Name                | Description                           | Default |
|---------------------|---------------------------------------|---------|
| `region`            | Primary AWS region                    | -       |
| `profile`           | AWS CLI profile to use                | -       |

## Outputs

| Output Name                   | Description                           | Purpose                                   |
|-------------------------------|---------------------------------------|-------------------------------------------|
| `global_accelerator_dns_name` | Global Accelerator DNS name           | Access point for accelerated traffic      |
| `us_east_1_ec2_public_ip`     | Public IP of us-east-1 EC2 instance   | Direct access to US East instance         |
| `us_east_1_ec2_public_dns`    | Public DNS of us-east-1 EC2 instance  | DNS-based access to US East instance      |
| `ap_south_1_ec2_public_ip`    | Public IP of ap-south-1 EC2 instance  | Direct access to Asia Pacific instance    |
| `ap_south_1_ec2_public_dns`   | Public DNS of ap-south-1 EC2 instance | DNS-based access to Asia Pacific instance |