# Section 19: Serverless Overview - Terraform Stack

This directory contains Terraform code for the Serverless Overview section of the AWS Solutions Architect Associate course.

## Overview

This Terraform stack demonstrates core AWS serverless services including Lambda, DynamoDB, API Gateway, and Cognito as part of the AWS Solutions Architect Associate certification study.

## Demonstrated Resources

The stack creates a complete serverless application with:

- **AWS Lambda Functions**: Serverless compute for business logic
- **Amazon DynamoDB**: NoSQL database for data storage
- **API Gateway**: RESTful API endpoints with Lambda integration

## Architecture Overview

### Lambda Functions
- `HelloWorld` - Basic Lambda function demonstration
- `api-gateway-root-get` - Handles GET requests to API root (`/`)
- `api-gateway-houses-get` - Handles GET requests to `/houses` endpoint

### DynamoDB
- `DemoTable` - Simple table with sample user data
- Pre-populated with demo records for testing

### API Gateway
- REST API with regional endpoint configuration
- Two endpoints: `/` and `/houses`
- Lambda proxy integration for both endpoints
- Deployed to `dev` stage

## Skipped Resources

### Advanced Lambda Features
- **Lambda SnapStart** - Cold start optimization for Java
- **Lambda@Edge & CloudFront Functions** - Edge computing
- **Lambda in VPC** - Private network access

### Advanced DynamoDB Features
- **DynamoDB Accelerator (DAX)** - In-memory caching
- **DynamoDB Streams** - Change data capture
- **TTL** - Time-to-live for automatic item expiration

### Additional Serverless Services
- **AWS Step Functions** - Workflow orchestration
- **RDS invoking Lambda** - Database triggers
- **Advanced Cognito features** - Identity federation, advanced flows

## Important Notes

### Reserved Concurrency Limitation
The Lambda reserved concurrency is commented out due to account limitations:
```hcl
# reserved_concurrent_executions = 20
```

**Why it's disabled**: AWS requires a minimum of 10 unreserved concurrent executions. If your account's total limit is low (e.g., 20), setting reserved concurrency would violate this requirement.

**To enable**: Request a service quota increase for Lambda concurrent executions:
```bash
aws service-quotas request-service-quota-increase \
  --service-code lambda \
  --quota-code L-B99A9384 \
  --desired-value 1000
```

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
5. Test the API endpoints:
   ```
   curl $(terraform output -raw api_invoke_url)/
   curl $(terraform output -raw api_invoke_url)/houses
   ```
6. Remember to destroy resources when done:
   ```
   terraform destroy
   ```

## API Endpoints

| Method | Path      | Function                 | Description          |
|--------|-----------|--------------------------|----------------------|
| GET    | `/`       | `api-gateway-root-get`   | Root endpoint        |
| GET    | `/houses` | `api-gateway-houses-get` | Houses data endpoint |

## Variables

| Name          | Description                                    | Default                     |
|---------------|------------------------------------------------|-----------------------------|
| `region`      | AWS region to deploy to                        | -                           |
| `profile`     | AWS CLI profile to use                         | -                           |
| `common_tags` | Common tags for all resources                  | `{ManagedBy = "terraform"}` |

## Sample terraform.tfvars

```hcl
region  = "us-east-2"
profile = "default"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
  Section     = "Serverless Overview SA"
}
```

## Outputs

| Output Name      | Description                          |
|------------------|--------------------------------------|
| `api_invoke_url` | API Gateway invoke URL for dev stage |
