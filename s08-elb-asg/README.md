# Elastic Load Balancing and Auto Scaling Groups

This directory contains Terraform configurations for AWS Elastic Load Balancing (ELB) and Auto Scaling Groups (ASG) covered in the Solutions Architect Associate course.

## Overview

The configuration demonstrates how to set up:
- Application Load Balancer (ALB)
- Target Groups and Listeners
- Auto Scaling Groups with Launch Templates
- Dynamic Scaling Policies

## Mixed State Warning

**Note:** This Terraform configuration is in a "mixed" state due to changes made during the course lessons:

- In the course videos, Stephane terminated all EC2 instances between creating the load balancers and auto scaling group
- In this implementation, the instances were not terminated, resulting in:
  - Some EC2 instances managed directly by Terraform (in `01-alb.tf`)
  - Additional instances managed by the Auto Scaling Group (in `03-asg.tf`)
  - Both sets of instances registered to the same load balancer target group

This means the load balancer will distribute traffic to both the standalone EC2 instances and the ASG-managed instances. While this works functionally, it's not a typical production setup where you would use either direct EC2 instances OR an ASG, but not both simultaneously.

## Components

### 1. Application Load Balancer
- Public-facing ALB in the default VPC
- HTTP listener on port 80
- Custom error page for "/error" path
- Security groups for ALB and EC2 instances

### 2. Target Group
- HTTP health checks
- Deregistration delay (connection draining)
- Optional stickiness configuration
- Cross-zone load balancing

### 3. Auto Scaling Group
- Launch template with user data for Apache installation
- Target tracking scaling policy based on CPU utilization (40%)
- Health check integration with the load balancer

## Testing Auto Scaling

To test the auto scaling policy:

1. SSH into an instance:
   ```
   ssh -i generated_key.pem ec2-user@<instance-ip>
   ```

2. Install the stress tool:
   ```
   sudo yum install -y stress
   ```

3. Generate CPU load:
   ```
   stress --cpu 1 --timeout 300s
   ```

4. Observe the Auto Scaling Group creating new instances as CPU utilization exceeds 40%

## Variables

| Name                       | Description                              | Default                       |
|----------------------------|------------------------------------------|-------------------------------|
| `region`                   | AWS region to deploy resources           | -                             |
| `profile`                  | AWS CLI profile to use                   | -                             |
| `amazon_linux_2023_ami_id` | AMI ID for Amazon Linux 2023             | -                             |
| `common_tags`              | Map of common tags to apply to resources | `{ ManagedBy = "terraform" }` |
| `alb_instances`            | The number of instances in the ALB       | 2                             |

## Outputs

| Name          | Description                                               |
|---------------|-----------------------------------------------------------|
| `compute_ips` | Public IP addresses of the directly managed EC2 instances |
| `alb_dns`     | DNS name of the Application Load Balancer                 |
| `nlb_dns`     | DNS name of the Network Load Balancer                     |

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Access the load balancers using their DNS names:
   ```
   terraform output alb_dns
   terraform output nlb_dns
   ```

4. Connect to individual instances if needed:
   ```
   terraform output compute_ips
   ssh -i generated_key.pem ec2-user@<instance-ip>
   ```

5. Clean up:
   ```
   terraform destroy
   ```