# Security Group Module

This module creates an AWS security group with common rules for web server access.

## Features

- Creates a security group in a specified VPC
- Configures inbound rules for SSH (port 22) with customizable CIDR
- Sets up inbound HTTP (port 80) access from anywhere
- Configures outbound access to all destinations

## Usage

```hcl
module "web_security_group" {
  source = "../modules/sec_grp"

  region         = "us-east-1"
  name           = "web-server-sg"
  vpc_id         = module.vpc.vpc_id
  ssh_cidr_block = "0.0.0.0/0"  # Restrict SSH access
}
```

Run the following to get your system's public IP address:
   ```
   curl checkip.amazonaws.com
   ```

## Inputs

| Name             | Description                     | Type     | Default     | Required |
|------------------|---------------------------------|----------|-------------|:--------:|
| `region`         | AWS region                      | `string` | `null`      | no       |
| `name`           | Name of the security group      | `string` | `null`      | no       |
| `ssh_cidr_block` | CIDR block for SSH access       | `string` | `0.0.0.0/0` | no       |
| `vpc_id`         | VPC ID for the security group   | `string` | `null`      | no       |

## Outputs

| Name    | Description                      |
|---------|----------------------------------|
| `sg_id` | ID of the created security group |

## Security Considerations

- By default, SSH access is allowed from any IP (0.0.0.0/0)
- Consider restricting SSH access to specific IP ranges
- HTTP access is open to facilitate web server demonstrations