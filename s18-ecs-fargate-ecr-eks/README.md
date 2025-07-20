# ECS, Fargate, ECR, & EKS

This directory contains Terraform code for the ECS, Fargate, ECR, & EKS section of the AWS Solutions Architect Associate course.

## Overview

This section demonstrates how to provision and configure AWS container services using Terraform, covering:

- Amazon ECS cluster with Fargate launch type
- ECS service with load balancer integration
- ECS task definitions with container specifications
- Application Load Balancer with target groups and listeners
- AWS App Runner service with auto-scaling configuration
- Security groups and IAM roles for container services

## Demonstrated Resources

- ECS cluster with service connect defaults
- ECS service running on Fargate with 3 desired instances
- ECS task definition using nginxdemos/hello container
- Application Load Balancer with HTTP listener
- Target group for IP-based load balancing
- App Runner service with public ECR image
- Auto-scaling configuration for App Runner
- Security groups for container and load balancer traffic
- IAM execution role for ECS tasks
- Service discovery HTTP namespace

## Topics Covered (Theory Only)

The following topics were covered in the course but do not have hands-on labs:

- Amazon EKS (Elastic Kubernetes Service)
- Amazon ECR (Elastic Container Registry)
- ECS with EC2 launch type
- Container insights and monitoring
- ECS service auto-scaling policies

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
5. Access the applications via the load balancer DNS name and App Runner URL
6. Remember to destroy resources when done:
   ```
   terraform destroy
   ```

## Important Notes

- ECS service uses Fargate launch type for serverless containers
- Load balancer DNS name provides access to the ECS service
- App Runner service URL provides direct access to the containerized application
- Security groups allow HTTP traffic on port 80
- Task definition specifies container resource requirements (512 CPU, 1024 MB memory)

## Sample terraform.tfvars

```hcl
region  = "us-west-2"
profile = "default"
common_tags = {
  Environment = "sandbox"
  CostCenter  = "education"
  Owner       = "Your Name"
}
```

## Variables

| Name          | Description                                      | Default |
|---------------|--------------------------------------------------|---------|
| `region`      | AWS region to deploy resources                   | -       |
| `profile`     | AWS CLI profile to use                           | -       |
| `common_tags` | Common tags applied to all resources             | -       |

## Outputs

| Output Name              | Description                           | Purpose                                    |
|--------------------------|---------------------------------------|--------------------------------------------|
| `load_balancer_dns`      | Application Load Balancer DNS name    | Access point for ECS service              |
| `app_runner_service_url` | App Runner service URL                | Direct access to App Runner application   |

## Resources Created

- `aws_ecs_cluster.demo` - ECS cluster
- `aws_ecs_service.demo` - ECS service with Fargate launch type
- `aws_ecs_task_definition.demo` - Task definition for nginx container
- `aws_lb.ecs_lb` - Application Load Balancer
- `aws_lb_target_group.ecs_lb_target_group` - Target group for load balancer
- `aws_lb_listener.ecs_lb_listener` - HTTP listener for load balancer
- `aws_apprunner_service.demo` - App Runner service
- `aws_apprunner_auto_scaling_configuration_version.demo_asc` - Auto-scaling config
- `aws_security_group.demo` - Security group for container traffic
- `aws_iam_role.ecsTaskExecutionRole` - IAM role for ECS task execution
- `aws_service_discovery_http_namespace.demo` - Service discovery namespace