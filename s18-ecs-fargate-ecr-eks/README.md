# IAM (Identity and Access Management)

This directory contains Terraform code for the IAM section of the AWS Solutions Architect Associate course.

## Overview

This section demonstrates AWS Identity and Access Management (IAM) using Terraform, covering:

- IAM users with secure password generation
- IAM groups and group memberships
- IAM policies and policy attachments
- Account password policies
- Multi-Factor Authentication (MFA) devices
- IAM roles for AWS services

## Demonstrated Resources

- IAM user with auto-generated 20-character password
- Admin group with AdministratorAccess policy
- Developers group with AlexaForBusinessDeviceSetup policy
- Account password policy with strict requirements
- Virtual MFA device for enhanced security
- IAM role for EC2 service with IAMReadOnlyAccess policy
- Direct user policy attachment (IAMReadOnlyAccess)

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
5. Retrieve the generated password:
   ```
   terraform output iam_user_password
   ```
6. Remember to destroy resources when done:
   ```
   terraform destroy
   ```

## Important Notes

- User passwords are auto-generated and marked as sensitive outputs
- Password reset is required on first login
- Account alias configuration is commented out by default
- MFA device requires manual setup after creation
- Admin group provides full AWS access - use carefully

## Sample terraform.tfvars

```hcl
region  = "us-east-1"
profile = "default"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
  Section     = "IAM"
}
iam_user_name = "saac03"
```

## Variables

| Name            | Description                                      | Default         |
|-----------------|--------------------------------------------------|-----------------|
| `region`        | AWS region to deploy resources                   | -               |
| `profile`       | AWS CLI profile to use                           | -               |
| `common_tags`   | Common tags applied to all resources             | `{ManagedBy = "terraform"}` |
| `iam_user_name` | Name for the IAM user                            | -               |

## Outputs

| Output Name         | Description                           | Sensitive |
|---------------------|---------------------------------------|-----------|
| `iam_user_password` | Auto-generated password for IAM user | Yes       |

## Resources Created

- `aws_iam_user.iam_user` - IAM user
- `aws_iam_user_login_profile.login_profile` - User login profile with password
- `aws_iam_group.admin_group` - Admin group
- `aws_iam_group.developers` - Developers group
- `aws_iam_group_membership.admin_group_membership` - Admin group membership
- `aws_iam_group_membership.developers` - Developers group membership
- `aws_iam_group_policy_attachment.admin_policy_attachment` - Admin policy attachment
- `aws_iam_group_policy_attachment.alexa_for_business_policy` - Alexa policy attachment
- `aws_iam_user_policy_attachment.iam_read_only_policy` - Direct user policy attachment
- `aws_iam_account_password_policy.strict` - Account password policy
- `aws_iam_virtual_mfa_device.mfa` - Virtual MFA device
- `aws_iam_role.demo_role_for_ec2` - IAM role for EC2
- `aws_iam_role_policy_attachment.demo_role_iam_read_only` - Role policy attachment

## Password Policy Configuration

The account password policy enforces:
- Minimum 8 characters
- Requires lowercase, uppercase, numbers, and symbols
- Allows users to change their own passwords
- Prevents password reuse (1 previous password)

## MFA Setup Instructions
  
1. After applying Terraform, manually set up the MFA device named `device-for-{iam_user_name}`
2. Uncomment the import block in `04-mfa.tf` to manage the device with Terraform
3. Run `terraform import` to bring the manually created device under Terraform management