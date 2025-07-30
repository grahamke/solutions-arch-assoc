# Section 24: Monitoring & Audit - Terraform Stack

This directory contains Terraform code for the Monitoring & Audit section of the AWS Solutions Architect Associate course.

## Overview

This Terraform stack demonstrates AWS monitoring and auditing services including CloudWatch Logs, CloudWatch Alarms, and EventBridge as part of the AWS Solutions Architect Associate certification study.

## Demonstrated Resources

The stack creates a comprehensive monitoring and alerting system with:

- **CloudWatch Log Groups**: Centralized log management and retention
- **CloudWatch Metric Filters**: Extract metrics from log data
- **CloudWatch Alarms**: Automated monitoring with EC2 termination actions
- **EventBridge**: Event-driven architecture with custom and default event buses
- **SNS Integration**: Email notifications for critical events

## Architecture Overview

### CloudWatch Logs
- `demo-log-group` - Main log group with unlimited retention
- `DemoLogGroup` - Secondary log group with 1-day retention
- `DemoLogStream` - Log stream for live tail demonstration
- **Metric Filter** - Extracts metrics when "Installing" pattern is found

### CloudWatch Alarms
- **CPU Utilization Alarm** - Monitors EC2 instance CPU usage
- **Automatic Termination** - Terminates instance when CPU > 95% for 3 consecutive periods
- **3 out of 3 datapoints** - Requires all evaluation periods to breach threshold

### EventBridge
- **Custom Event Bus** (`central-event-bus`) - For application events
- **Event Archive** - Stores events for replay and analysis
- **Schema Discovery** - Automatically infers event schemas
- **EC2 State Change Rule** - Monitors instance stopped/terminated events
- **SNS Integration** - Email notifications for EC2 state changes

### EC2 Instance
- Amazon Linux 2023 instance for monitoring demonstration
- Integrated with CloudWatch alarm for automatic termination

## Skipped Resources

### AWS Config
- **Configuration Recording** - Track resource configuration changes
- **Compliance Rules** - Automated compliance checking
- **Remediation Actions** - Automatic fixes for non-compliant resources
- **Multi-Account/Region Setup** - Centralized configuration management

### Advanced CloudWatch Features
- **CloudWatch Insights** - Log querying and analysis
- **CloudWatch Synthetics** - Website and API monitoring
- **CloudWatch RUM** - Real user monitoring
- **Custom Metrics** - Application-specific metrics
- **CloudWatch Agent** - Enhanced system metrics

### Advanced EventBridge Features
- **Cross-Account Event Sharing** - Multi-account event routing
- **Event Replay** - Replaying archived events
- **Dead Letter Queues** - Failed event handling
- **Input Transformers** - Event data transformation

## Important Notes

### Email Subscription
The SNS email subscription requires manual confirmation:
1. Check your email after deployment
2. Click the confirmation link to activate notifications

### EC2 Termination Warning
The CloudWatch alarm will **automatically terminate** the EC2 instance when CPU exceeds 95% for 15 minutes (3 × 5-minute periods). This is intentional for demonstration purposes.

### Event Bus Isolation
- **Default Bus**: Receives AWS service events (EC2, S3, etc.)
- **Custom Bus**: For application-specific events only
- Rules can target either bus independently

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
5. Confirm SNS email subscription when prompted
6. Test log ingestion and monitoring features
7. Remember to destroy resources when done:
   ```
   terraform destroy
   ```

## Testing the Stack

### Log Ingestion
```bash
# Send test log entries
aws logs put-log-events \
  --log-group-name demo-log-group \
  --log-stream-name test-stream \
  --log-events timestamp=$(date +%s000),message="Installing package xyz"
```

### Live Tail
```bash
# Monitor logs in real-time
aws logs tail DemoLogGroup --follow
```

### Alarm Testing
```bash
# Stress test EC2 instance to trigger alarm
sudo yum install -y stress
stress --cpu 1 --timeout 1200s
```

## Variables

| Name                             | Description                              | Default                     |
|----------------------------------|------------------------------------------|-----------------------------|
| `region`                         | AWS region to deploy to                  | -                           |
| `profile`                        | AWS CLI profile to use                   | -                           |
| `common_tags`                    | Common tags for all resources            | `{ManagedBy = "terraform"}` |
| `sns_subscription_email_address` | Email for EC2 state change notifications | -                           |

## Sample terraform.tfvars

```hcl
region  = "us-east-2"
profile = "default"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
  Section     = "Monitoring & Audit"
}
sns_subscription_email_address = "your.email@example.com"
```

## Monitoring Resources

| Resource Type    | Name                    | Purpose                     |
|------------------|-------------------------|-----------------------------|
| Log Group        | `demo-log-group`        | Main application logs       |
| Log Group        | `DemoLogGroup`          | Live tail demonstration     |
| Metric Filter    | `DemoFilter`            | Extract metrics from logs   |
| CloudWatch Alarm | `TerminateEC2OnHighCPU` | Monitor and terminate EC2   |
| Event Bus        | `central-event-bus`     | Custom application events   |
| Event Rule       | `DemoRuleEventBridge`   | EC2 state change monitoring |
| SNS Topic        | `demo-topic`            | Email notifications         |

## Event Patterns

The EventBridge rule monitors EC2 instances with this pattern:
```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["stopped", "terminated"]
  }
}
```