# AWS Solutions Architect Associate – Terraform Exercises

This repository contains Terraform code created while following along with the hands-on sections of **Stéphane Maarek's AWS Certified Solutions Architect – Associate** course on Udemy.

Additional experimentation code may be added.

## 📚 Course Info

- **Instructor:** Stéphane Maarek
- **Platform:** Udemy
- **Course:** [AWS Certified Solutions Architect – Associate SAA-C03](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/)

## 🚀 Purpose

The goal of this repository is to:

- Practice Infrastructure as Code (IaC) using Terraform
- Deploy and manage AWS resources in a repeatable way
- Reinforce concepts covered in the AWS SAA-C03 certification exam

## 📁 Repository Structure

```
.
├── README.md
├── budget-limit/
│   ├── budget.tf
│   ├── variables.tf
│   └── ...
├── s05-ec2-fundamentals/
│   ├── 01-budget.tf
│   ├── 02-ec2.tf
│   └── ...
├── s06-ec2-saa/
│   ├── main.tf
│   ├── variables.tf
│   └── ...
└── ...
```

Each subdirectory represents a hands-on lab or section from the course.

## ⚠️ Important: Isolated Terraform Stacks

Each directory in this repository is designed to be an **isolated Terraform stack** that should be managed independently:

- **Work on one section at a time** - Each section should be planned, applied, and destroyed separately
- **Resource duplication** - Some resources (like budgets) are intentionally duplicated between sections
- **Independent state files** - Each directory maintains its own Terraform state
- **Destroy resources when done** - Remember to run `terraform destroy` in each directory when finished with that section

This isolation ensures that you can work through the course sections independently without affecting other resources.

## 🔍 "Hidden" Resources Made Explicit

When creating resources through the AWS Console, AWS often creates additional supporting resources automatically for convenience. These "hidden" resources are not always evident to users but are necessary for the primary resources to function correctly.

For example:
- Creating an Auto Scaling Group in the console automatically creates a service-linked IAM role
- Setting up a VPC creates default security groups, network ACLs, and route tables
- Launching an EC2 instance may create default EBS volumes and security groups

In this repository, these "hidden" resources are explicitly defined in the Terraform code. This provides several benefits:

- **Complete transparency** of all resources being created
- **Better understanding** of AWS service dependencies and relationships
- **Full control** over all resource configurations
- **Educational value** in seeing the complete infrastructure requirements

This explicit approach helps develop a deeper understanding of AWS architecture while ensuring no unexpected resources are created.

## 💰 Cost Management with Terraform

Using Terraform for these exercises provides significant advantages for cost control:

- **Complete Resource Tracking**: Terraform maintains a state file that tracks all provisioned resources, ensuring nothing is forgotten
- **One-Command Cleanup**: Running `terraform destroy` removes all resources defined in the configuration, preventing costly orphaned resources
- **Resource Visualization**: The `terraform plan` command shows exactly what will be created, modified, or destroyed
- **Cost Estimation**: Compatible with tools like Infracost to estimate AWS expenses before deployment
- **Consistent Environments**: Ensures lab environments are identical each time, making cost patterns predictable

This approach significantly reduces the risk of leaving expensive resources running after completing exercises, which is a common issue when manually creating resources in the AWS console.

### AWS Budget Alerts

The repository includes a dedicated `budget-limit` directory with a Terraform stack that sets up AWS Budget alerts. This stack can be deployed independently and left running throughout the course to monitor your AWS spending.

**Setup Instructions:**

1. Navigate to the budget-limit directory:
   ```
   cd budget-limit
   ```

2. Configure your budget settings in `terraform.tfvars`:
   ```
   region               = "us-east-1"  # Your preferred region
   profile              = "default"    # Your AWS CLI profile
   budget_limit_amount  = "10.0"       # Maximum budget in USD
   budget_email_address = "your.email@example.com"
   ```

3. Deploy the budget alert:
   ```
   terraform init
   terraform apply
   ```

4. Leave this budget stack running even when destroying other resources

The budget configuration will:
- Set a monthly cost budget with your specified limit
- Send email alerts when you reach 85% and 100% of your budget
- Send an alert if the forecasted spend will exceed your budget

This helps ensure you don't accidentally incur unexpected AWS charges while working through the course exercises.


## 🛠️ Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- An AWS account and IAM credentials (preferably configured via `~/.aws/credentials`)

## 🔒 Note

This project is for personal learning purposes only. No sensitive information (such as AWS credentials) is stored in this repository.

## 📌 Disclaimer

This repository is not affiliated with Stéphane Maarek or Udemy. It is a personal companion project to reinforce learning objectives from the course.

---

Happy Terraforming! 🌍
