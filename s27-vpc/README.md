# VPC Networking

This directory contains Terraform code for comprehensive VPC networking setup from the AWS Solutions Architect Associate course.

## Overview

This section demonstrates AWS VPC networking using Terraform, covering:

- VPC creation with IPv4 and IPv6 CIDR blocks
- Public and private subnets across multiple availability zones
- Internet Gateway and NAT Gateway configuration
- Bastion host and private instance deployment
- VPC peering between custom and default VPCs
- VPC endpoints for private AWS service access
- VPC Flow Logs with S3 and CloudWatch destinations
- Egress-Only Internet Gateway for IPv6 outbound traffic

## Demonstrated Resources

- Custom VPC with IPv4 and IPv6 CIDR blocks
- Public and private subnets in multiple availability zones
- Internet Gateway for public subnet internet access
- NAT Gateway for private subnet outbound internet access
- Bastion host in public subnet for secure private access
- Private EC2 instance with IAM role for S3 access
- VPC peering connection between custom and default VPCs
- S3 VPC endpoint for private AWS service connectivity
- VPC Flow Logs to S3 and CloudWatch
- Athena workgroup and database for flow log analysis
- Egress-Only Internet Gateway for IPv6 outbound traffic

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
5. Check your IP address for security group access:
   ```
   curl checkip.amazonaws.com
   ```
6. Connect to bastion host:
   ```
   ssh -i generated_key.pem ec2-user@<bastion_public_ip>
   ```
7. Connect to private instance from bastion:
   ```
   ssh -i private_key.pem ec2-user@<private_instance_ip>
   ```
8. Remember to destroy resources when done:
   ```
   terraform destroy
   ```

## Important Notes

- Private instance security group requires egress rule for internet access
- Custom Athena workgroup created for flow log analysis
- CloudWatch log group may require manual cleanup
- IPv6 SSH requires additional configuration
- NAT Instance exercise skipped in favor of NAT Gateway
- Network ACLs exercise skipped

## Sample terraform.tfvars

```hcl
region  = "us-east-2"
profile = "default"
common_tags = {
  Environment = "Development"
  Project     = "SAA-C03"
  CostCenter  = "education"
  Owner       = "Your Name"
  Section     = "VPC"
}
s3_flow_logs_bucket_name       = "your-vpc-flow-logs"
flow_logs_aggregation_interval = 60
```

## Variables

| Name                             | Description                                    | Default |
|----------------------------------|------------------------------------------------|---------|
| `region`                         | AWS region to deploy resources                 | -       |
| `profile`                        | AWS CLI profile to use                         | -       |
| `common_tags`                    | Common tags applied to all resources           | `{ManagedBy = "terraform"}` |
| `vpc_name`                       | Name for the VPC                              | `"DemoVPC"` |
| `s3_flow_logs_bucket_name`       | S3 bucket name for VPC flow logs              | -       |
| `flow_logs_aggregation_interval` | Flow logs aggregation interval in seconds     | `600`   |

## Outputs

| Output Name                        | Description                           |
|------------------------------------|---------------------------------------|
| `bastion_host_public_ip`           | Public IP address of bastion host     |
| `bastion_host_public_ipv6`         | IPv6 addresses of bastion host        |
| `aws_instance_private_host_private_ip` | Private IP of private instance    |
| `default_vpc_instance_public_ip`   | Public IP of default VPC instance     |
| `eip_ip_address`                   | Elastic IP address for NAT Gateway    |

## Resources Created

- `aws_vpc.demo_vpc` - Custom VPC with IPv4/IPv6
- `aws_subnet.public_a/b` - Public subnets
- `aws_subnet.private_a/b` - Private subnets
- `aws_internet_gateway.demo_igw` - Internet gateway
- `aws_nat_gateway.demo_nat_gw` - NAT gateway
- `aws_instance.bastion_host` - Bastion host instance
- `aws_instance.private_host` - Private instance
- `aws_vpc_peering_connection.demo_vpc_peering_connection` - VPC peering
- `aws_vpc_endpoint.demo_s3_vpc_endpoint` - S3 VPC endpoint
- `aws_flow_log.demo_s3_flow_log` - S3 flow logs
- `aws_flow_log.demo_cw_flow_log` - CloudWatch flow logs
- `aws_egress_only_internet_gateway.demo_eigw` - IPv6 egress gateway

## Flow Log Analysis

After applying this configuration:
1. Go to the Athena console
2. Select the `flow_logs_workgroup`
3. Run the saved query to create the table
4. Query your VPC Flow Logs:
   ```sql
   SELECT *
   FROM vpc_flow_logs
   LIMIT 10;
   ```

## Additional Notes

- **Security Groups**:
  - Noticed that the private EC2 instance's security group lacked an egress rule, which was necessary for outbound internet access. I manually added this rule to ensure functionality.
- **Athena Workgroup**:
  - Encountered complications referencing the primary workgroup for Athena. I created a new workgroup to complete exercises via the Athena console.
- **CloudWatch Log Group**:
  - Observed that the CloudWatch log group for VPC flow logs was not destroyed during `terraform destroy`. Had to manually import the log group into the Terraform state, possibly due to a race condition.
- **SSH over IPv6**:
  - To SSH into instances using IPv6, added the IPv6 address to `/etc/hosts`.
  - Alternatively, configured the SSH client by adding the following to `~/.ssh/config`:

    ```ssh
    Host bastion
        HostName <ipv6 of bastion host>
        User ec2-user
        IdentityFile ~/generated_key.pem
        AddressFamily inet6
    ```
