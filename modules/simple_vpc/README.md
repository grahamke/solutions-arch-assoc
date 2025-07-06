# Simple VPC Module

This module creates a basic AWS VPC with internet connectivity and two public subnets.

## Features

- Creates a VPC with customizable CIDR block
- Provisions an Internet Gateway for public internet access
- Creates two public subnets in different availability zones
- Sets up route tables with internet access
- Configures subnet associations with the route table

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

| Name         | Description                | Type     | Default          | Required |
|--------------|----------------------------|----------|------------------|:--------:|
| `region`     | AWS region                 | `string` | `null`           | no       |
| `cidr_block` | CIDR block for the VPC     | `string` | `172.16.0.0/24`  | no       |
| `vpc_name`   | Name of the VPC            | `string` | `simple`         | no       |

## Outputs

| Name         | Description                                |
|--------------|--------------------------------------------|
| `vpc_id`     | ID of the created VPC                      |
| `subnet_ids` | List of subnet IDs (subnet_a and subnet_b) |

## Architecture

- VPC with specified CIDR block
- Internet Gateway attached to the VPC
- Two subnets in different availability zones (region-a, region-b)
- Route table with default route to the Internet Gateway
- Subnet associations with the route table

## Network Design

- Subnet A: First half of the VPC CIDR block (e.g., 172.16.0.0/25 for a /24 VPC)
- Subnet B: Second half of the VPC CIDR block (e.g., 172.16.0.128/25 for a /24 VPC)