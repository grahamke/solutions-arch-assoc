# SQS, SNS, Kinesis, & Amazon MQ

This directory contains Terraform code for the SQS, SNS, Kinesis, & Amazon MQ section of the AWS Solutions Architect Associate course.

## Overview

This section demonstrates how to provision and configure AWS messaging and streaming services using Terraform, covering:

- Amazon SQS standard queues with visibility timeout and message retention
- Amazon SQS FIFO queues with content-based deduplication
- Amazon SNS topics with email subscriptions
- Amazon Kinesis Data Streams with provisioned shards
- Amazon Kinesis Data Firehose with S3 delivery
- IAM roles and policies for service integration

## Demonstrated Resources

- SQS standard queue with configurable parameters
- SQS FIFO queue with ordering guarantees
- SNS topic with email subscription endpoint
- Kinesis Data Stream with single shard configuration
- Kinesis Data Firehose delivery stream to S3
- S3 bucket for Firehose data delivery
- IAM roles for Firehose service permissions
- IAM policies for S3 and Kinesis access

## Topics Covered (Theory Only)

The following topics were covered in the course but do not have hands-on labs:

- SQS long polling configuration and benefits
- SQS integration with Auto Scaling Groups
- Amazon MQ managed message broker service
- Dead letter queues and message retry patterns
- SNS message filtering and fan-out patterns

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
5. Test the messaging services through AWS Console or CLI
6. Remember to destroy resources when done (empty the S3 bucket):
      ```
      terraform destroy
      ```

## Important Notes

- SQS queues support both standard and FIFO message ordering
- SNS email subscriptions require manual confirmation
- Kinesis Data Streams use provisioned throughput mode
- Firehose automatically delivers data to S3 with configurable buffering
- IAM roles follow least privilege principle for service access

## Sample terraform.tfvars

```hcl
region  = "us-west-2"
profile = "default"
common_tags = {
  Environment = "Sandbox"
  CostCenter  = "education"
  Owner       = "Your Name"
  Section     = "Decoupling applications: SQS SNS Kinesis Active MQ"
}
sns_subscription_email_address = "your-email@example.com"
firehose_bucket_name          = "your-unique-firehose-bucket-name"
```

## Variables

| Name                           | Description                                    | Default |
|--------------------------------|------------------------------------------------|---------|
| `region`                       | AWS region to deploy resources                 | -       |
| `profile`                      | AWS CLI profile to use                         | -       |
| `common_tags`                  | Common tags applied to all resources           | -       |
| `sns_subscription_email_address` | Email address for SNS topic subscription    | -       |
| `firehose_bucket_name`         | S3 bucket name for Firehose delivery          | -       |

## Resources Created

- `aws_sqs_queue.demo` - Standard SQS queue
- `aws_sqs_queue.demo_fifo` - FIFO SQS queue
- `aws_sns_topic.demo` - SNS topic
- `aws_sns_topic_subscription.demo` - Email subscription
- `aws_kinesis_stream.demo` - Kinesis Data Stream
- `aws_kinesis_firehose_delivery_stream.demo` - Firehose delivery stream
- `aws_s3_bucket.firehose_bucket` - S3 destination bucket
- IAM roles and policies for service integration