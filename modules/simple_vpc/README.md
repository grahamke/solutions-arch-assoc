# Simple VPC Module

This module creates a basic AWS VPC with internet connectivity, two public subnets, and two private subnets.

## Features

- Creates a VPC with customizable CIDR block
- Provisions an Internet Gateway for public internet access
- Creates two public subnets in different availability zones
- Creates two private subnets in different availability zones
- Sets up route tables with internet access for public subnets
- Configures subnet associations with the route table
- Supports DNS hostnames and DNS support configuration

## Usage

```hcl
module "application_vpc" {
  source = "../modules/simple_vpc"

  region     = "us-east-1"
  vpc_name   = "application-vpc"
  cidr_block = "10.0.0.0/16"
}
```

## Inputs

| Name                   | Description                | Type     | Default          | Required |
|------------------------|----------------------------|----------|------------------|:--------:|
| `region`               | AWS region                 | `string` | `null`           | no       |
| `cidr_block`           | CIDR block for the VPC     | `string` | `172.16.0.0/24`  | no       |
| `vpc_name`             | Name of the VPC            | `string` | `simple`         | no       |
| `enable_dns_support`   | Enables DNS support in VPC | `bool`   | `true`           | no       |
| `enable_dns_hostnames` | Enables DNS hostnames      | `bool`   | `false`          | no       |

## Outputs

| Name                    | Description                                           |
|-------------------------|-------------------------------------------------------|
| `vpc_id`                | The ID of the VPC                                     |
| `public_subnet_ids`     | A list of the public subnet IDs                      |
| `private_subnet_ids`    | A list of the private subnet IDs                     |
| `public_route_table_id` | The ID of the route table associated with the public subnets |

## Architecture

- VPC with specified CIDR block
- Internet Gateway attached to the VPC
- Two public subnets in different availability zones (region-a, region-b)
- Two private subnets in different availability zones (region-a, region-b)
- Single route table with default route (0.0.0.0/0) to the Internet Gateway
- Route table associations for public subnets only

## Network Design

The module uses `cidrsubnet()` function to automatically divide the VPC CIDR block into four equal subnets:

- **Public Subnet A**: First quarter of VPC CIDR (cidrsubnet index 0) in availability zone `{region}a`
- **Public Subnet B**: Second quarter of VPC CIDR (cidrsubnet index 1) in availability zone `{region}b`
- **Private Subnet A**: Third quarter of VPC CIDR (cidrsubnet index 2) in availability zone `{region}a`
- **Private Subnet B**: Fourth quarter of VPC CIDR (cidrsubnet index 3) in availability zone `{region}b`

For example, with a `10.0.0.0/16` VPC CIDR:
- Public Subnet A: `10.0.0.0/18`
- Public Subnet B: `10.0.64.0/18`
- Private Subnet A: `10.0.128.0/18`
- Private Subnet B: `10.0.192.0/18`

**Note**: Private subnets have no route table associations and therefore no internet access.