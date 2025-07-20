# EC2 Instance Module

This module creates an AWS EC2 instance with configurable settings for networking, security, and metadata options.

## Features

- Creates an EC2 instance with customizable instance type
- Supports public IP association
- Configures IMDSv2 by default for enhanced security
- Allows custom user data for instance initialization
- Supports VPC security groups and subnet placement

## Usage

```hcl
module "web_server" {
  source = "../modules/ec2"

  region    = "us-east-1"
  ami       = "ami-12345678"
  key_name  = module.key_pair.key_name
  public_ip = true
  
  vpc_security_group_ids = [module.security_group.sg_id]
  subnet_id              = module.vpc.subnet_ids[0]
  
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF
  
  tags = {
    Name = "WebServer"
  }
}
```

## Inputs

| Name                     | Description                   | Type           | Default      | Required |
|--------------------------|-------------------------------|----------------|--------------|:--------:|
| `ami`                    | AMI ID for the instance       | `string`       | -            |   yes    |
| `instance_type`          | EC2 instance type             | `string`       | `"t2.micro"` |    no    |
| `key_name`               | SSH key pair name             | `string`       | `null`       |    no    |
| `public_ip`              | Whether to assign a public IP | `bool`         | `true`       |    no    |
| `region`                 | AWS region                    | `string`       | `null`       |    no    |
| `user_data`              | User data script              | `string`       | `null`       |    no    |
| `tags`                   | Resource tags                 | `map(string)`  | `null`       |    no    |
| `subnet_id`              | Subnet ID for the instance    | `string`       | `null`       |    no    |
| `vpc_security_group_ids` | List of security group IDs    | `list(string)` | `null`       |    no    |

## Outputs

| Name          | Description                           |
|---------------|---------------------------------------|
| `public_ip`   | Public IP address of the EC2 instance |
| `public_dns`  | Public DNS name of the EC2 instance   |
| `instance_id` | ID of the EC2 instance                |

## Security Considerations

- IMDSv2 is enforced by default for improved security
- Consider restricting SSH access in the security groups
- Use a custom AMI with hardened configuration for production