# Default VPC Security Group Module

This module creates a security group in the default VPC of your provider with simple access rules for EC2 instances. It replicates the create new security group from the AWS Console when launching a new instance.

## Features

- Creates a security group in the default VPC
- Configures inbound rules for SSH (port 22) and HTTP (port 80)
- Sets up outbound access to all destinations
- Ensures the default VPC has proper internet gateway routing

## Usage

```hcl
module "default_vpc_sg" {
  source = "../modules/default_vpc_sg"
}

resource "aws_instance" "web" {
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.default_vpc_sg.sg_id]
}
```


Run the following to get your system's public IP address:
   ```
   curl checkip.amazonaws.com
   ```

## Inputs

| Name             | Description                     | Type     | Default     | Required |
|------------------|---------------------------------|----------|-------------|:--------:|
| `ssh_cidr_block` | CIDR block for SSH access       | `string` | `0.0.0.0/0` | no       |


## Outputs

| Name    | Description                      |
|---------|----------------------------------|
| `sg_id` | ID of the created security group |

## Resources Created

- `aws_security_group` - Security group for EC2 instances
- `aws_vpc_security_group_ingress_rule` - Inbound rules for SSH and HTTP
- `aws_vpc_security_group_egress_rule` - Outbound rule allowing all traffic
- `aws_default_vpc` - Reference to the default VPC
- `aws_default_route_table` - Updates the default route table with internet access

## Security Considerations

- This module allows SSH and HTTP access from any IP (0.0.0.0/0)
- HTTP access is open to facilitate web server demonstrations