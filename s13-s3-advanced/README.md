# S3 Advanced Features - Terraform Examples

This directory contains Terraform configurations demonstrating advanced Amazon S3 features covered in the AWS Solutions Architect Associate course.

## Files Overview

- **[01-lifecycle-rules.tf](01-lifecycle-rules.tf)** - S3 lifecycle policies for storage class transitions
- **[02-event-notifications.tf](02-event-notifications.tf)** - S3 event notifications with SQS and EventBridge
- **[provider.tf](provider.tf)** - AWS provider configuration
- **[variables.tf](variables.tf)** - Variable definitions
- **[terraform.tfvars](terraform.tfvars)** - Variable values
- **[coffee.jpg](../resources/coffee.jpg)** - Sample image file for testing

## Learning Objectives

This configuration demonstrates:

- **Lifecycle Rules**: Automated storage class transitions and object expiration
- **Event Notifications**: S3 event integration with SQS queues and EventBridge
- **Storage Optimization**: Cost-effective data management through lifecycle policies
- **Event-Driven Architecture**: Triggering workflows based on S3 object events

## Usage

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

4. **Test event notifications**:
   - Upload objects to the S3 bucket
   - Check SQS queue for notification messages
   - Monitor EventBridge for events

5. **Clean up resources**:
   ```bash
   terraform destroy
   ```

## Resources Created

- **S3 Bucket**: With lifecycle configuration and event notifications
- **S3 Lifecycle Configuration**: Automated storage class transitions
- **S3 Bucket Notification**: Event notification configuration
- **SQS Queue**: For receiving S3 event notifications
- **SQS Queue Policy**: Allowing S3 to send messages
- **S3 Object**: Sample coffee.jpg file for testing

## Configuration Details

### Lifecycle Rules
The lifecycle configuration includes transitions through multiple storage classes:
- **Day 30**: STANDARD → STANDARD_IA
- **Day 60**: STANDARD_IA → INTELLIGENT_TIERING
- **Day 90**: INTELLIGENT_TIERING → GLACIER_IR
- **Day 180**: GLACIER_IR → GLACIER
- **Day 365**: GLACIER → DEEP_ARCHIVE
- **Day 700**: Object expiration

### Event Notifications
- **SQS Integration**: Object creation events sent to SQS queue
- **EventBridge Integration**: All S3 events forwarded to EventBridge
- **IAM Permissions**: Proper queue policy for S3 service access

## Variables

| Name          | Description                              | Default                       |
|---------------|------------------------------------------|-------------------------------|
| `region`      | AWS region to deploy resources           | -                             |
| `profile`     | AWS CLI profile to use                   | -                             |
| `common_tags` | Common tags to apply to all resources    | `{ ManagedBy = "terraform" }` |
| `bucket_name` | Name of the S3 bucket for demonstrations | -                             |

## Important Notes

- **Cost Awareness**: Lifecycle rules help optimize storage costs over time
- **Event Volume**: High-frequency S3 events can generate many SQS messages
- **Permissions**: The SQS queue policy is configured to allow only the specific S3 bucket
- **Testing**: Upload/delete objects to trigger notifications and test the configuration

## Related AWS Services

- **Amazon S3**: Object storage with advanced features
- **Amazon SQS**: Message queuing for event notifications
- **Amazon EventBridge**: Event routing and processing
- **AWS IAM**: Identity and Access Management for service permissions

---

**Remember**: Always run `terraform destroy` when finished to avoid ongoing charges!