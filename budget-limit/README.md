# AWS Budget Limit

To assist in monitoring and alarming when going over a set budget throughout this course, create this terraform stack.

## Purpose

This budget configuration has been separated into its own stack so it can be applied independently of the EC2 fundamentals stack in the `s05-ec2-fundamentals` directory. This allows you to:

1. Keep the budget active even if you destroy the EC2 resources
2. Maintain cost visibility throughout the course
3. Avoid accidentally removing budget alerts when cleaning up other resources

## Budget Configuration

The budget is configured with the following settings:

- **Type**: Cost budget
- **Amount**: Configurable via `budget_limit_amount` variable (default: $10.00 USD)
- **Time Period**: Monthly
- **Notifications**:
  - When actual spend reaches 85% of the budget
  - When actual spend reaches 100% of the budget
  - When forecasted spend exceeds 100% of the budget

All notifications are sent to the email address specified in the `budget_email_address` variable.

## Required Variables

| Variable Name          | Description                                   | Default                       |
|------------------------|-----------------------------------------------|-------------------------------|
| `region`               | AWS region to deploy the budget               | -                             |
| `profile`              | AWS CLI profile to use                        | -                             |
| `budget_limit_amount`  | Budget amount in USD                          | "10.0"                        |
| `budget_email_address` | Email address to receive budget notifications | -                             |
| `common_tags`          | Map of tags to apply to resources             | `{ ManagedBy = "terraform" }` |

## Usage

1. Configure the variables in `terraform.tfvars`
2. Initialize Terraform: `terraform init`
3. Apply the configuration: `terraform apply`

You can modify the budget amount at any time by updating the `budget_limit_amount` variable and running `terraform apply` again.