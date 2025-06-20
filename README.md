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
