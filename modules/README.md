# Terraform Modules

This directory contains reusable Terraform modules for the AWS Solutions Architect Associate course.
They make it easier in the later sections. Full implementations are initially found in the earlier sections.

## Available Modules

| Module Name      | Description                                                          |
|------------------|----------------------------------------------------------------------|
| `key_pair`       | Creates an AWS key pair with local storage of the private key        |
| `default_vpc_sg` | Sets up a security group in the default VPC with SSH and HTTP access |

## Usage

Import these modules in your Terraform configurations:

```hcl
module "ec2_key_pair" {
  source = "../modules/key_pair"

  key_name = "my-key"
  filename = "${path.module}/my-key.pem"
  tags = {
    Name = "My EC2 Key Pair"
  }
}

module "default_vpc_sg" {
  source = "../modules/default_vpc_sg"
}
```

## Module Dependencies

- `default_vpc_sg` - No dependencies on other modules
- `key_pair` - No dependencies on other modules

## Best Practices
1. Review the individual module README files for detailed usage instructions
1. Consider the security implications of the default settings