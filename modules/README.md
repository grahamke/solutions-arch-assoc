# Terraform Modules

This directory contains reusable Terraform modules for the AWS Solutions Architect Associate course.
They make it easier in the later sections. Full implementations are initially found in the earlier sections.

## Available Modules

| Module Name      | Description                                                          |
|------------------|----------------------------------------------------------------------|
| `default_vpc_sg` | Sets up a security group in the default VPC with SSH and HTTP access |
| `ec2`            | Creates an EC2 instance with configurable settings                   |
| `key_pair`       | Creates an AWS key pair with local storage of the private key        |
| `s3-website`     | Creates a simple S3 static website                                   |
| `sec_grp`        | Creates a security group with SSH and HTTP access rules              |
| `simple_vpc`     | Creates a VPC with internet gateway and two public subnets           |


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

module "vpc" {
  source     = "../modules/simple_vpc"
  region     = "us-east-1"
  vpc_name   = "application-vpc"
  cidr_block = "10.0.0.0/16"
}

module "security_group" {
  source = "../modules/sec_grp"
  region = "us-east-1"
  name   = "web-server-sg"
  vpc_id = module.vpc.vpc_id
}

module "web_server" {
  source = "../modules/ec2"
  region = "us-east-1"
  ami    = "ami-12345678"
  
  vpc_security_group_ids = [module.security_group.sg_id]
  subnet_id              = module.vpc.subnet_ids[0]
}
```

## Module Dependencies

- `default_vpc_sg` - No dependencies on other modules
- `key_pair` - No dependencies on other modules
- `ec2` - May depend on `key_pair`, `sec_grp`, and `simple_vpc` modules
- `sec_grp` - May depend on `simple_vpc` module
- `simple_vpc` - No dependencies on other modules

## Best Practices
1. Review the individual module README files for detailed usage instructions
2. Consider the security implications of the default settings
3. Use region-specific AMIs for EC2 instances
4. Restrict SSH access to specific IP ranges when possible

## Security Enhancements

### Restricting SSH Access to Your Current IP

For improved security, restrict SSH access to your current public IP address:

```hcl
# Get your current public IP address
terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}

# Use the IP in the security group
module "security_group" {
  source = "../modules/sec_grp"
  
  region         = "us-east-1"
  name           = "restricted-ssh-sg"
  vpc_id         = module.vpc.vpc_id
  ssh_cidr_block = "${chomp(data.http.my_ip.response_body)}/32"
}
```

This approach:
- Dynamically fetches your current public IP address
- Restricts SSH access to only your IP with a /32 CIDR block
- Uses `chomp()` to remove any trailing newlines from the IP address