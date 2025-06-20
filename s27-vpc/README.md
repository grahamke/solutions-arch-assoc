# Section 27 – VPC Networking with Terraform

This section implements a comprehensive VPC networking setup using Terraform, following the hands-on exercises from Stéphane Maarek's AWS Solutions Architect Associate course with additional customizations and observations.

## Required Variables

To use this Terraform stack, create a `terraform.tfvars` file with the following variables:

| Variable Name                    | Description                                              | Example Value             |
|----------------------------------|----------------------------------------------------------|---------------------------|
| `region`                         | AWS region where resources will be created               | `"us-east-1"`             |
| `profile`                        | AWS CLI profile to use                                   | `"your-profile-name"`     |
| `amazon_linux_2023_ami_id`       | AWS Linux 2023 AMI (find non-minimal for your region)    | `"ami-0953476d60561c955"` |
| `home_ip_address`                | Your IP address for security group rules (CIDR notation) | `"x.x.x.x/32"`            |
| `s3_flow_logs_bucket_name`       | Name for the S3 bucket storing VPC flow logs             | `"your-vpc-flow-logs"`    |
| `flow_logs_aggregation_interval` | Interval in seconds for VPC flow logs aggregation        | `60`                      |

### Example terraform.tfvars

```hcl
region = "us-east-1"
profile = "your-profile-name"
common_tags = {
  Environment = "Development"
  Project     = "ProjectName"
  CostCenter  = "CostCenterName"
  Owner       = "Your Name"
  Section     = "VPC"
}
home_ip_address = "x.x.x.x/32"
s3_flow_logs_bucket_name = "XXXXXXXXXXXXXXXXXX"
flow_logs_aggregation_interval = 60
```

## ✅ Resources Implemented

- **VPC**: Created a VPC with a single IPv4 CIDR block.
- **Subnets**:
  - **Public Subnet**: For resources requiring internet access.
  - **Private Subnet**: For internal resources without direct internet exposure.
- **Internet Gateway (IGW)**: Attached to the VPC to enable internet access for the public subnet.
- **Route Tables**:
  - Configured route tables with routes to `0.0.0.0/0` via the IGW for the public subnet.
- **Bastion Host**: Deployed in the public subnet to facilitate SSH access to instances in the private subnet.
- **NAT Gateway**: Implemented to allow instances in the private subnet to access the internet securely.
- **VPC Peering**: Established peering between the demo VPC and the default VPC to enable inter-VPC communication.
- **VPC Endpoint**: Added to allow private connectivity to AWS services without traversing the internet.
- **VPC Flow Logs**: Enabled to capture information about the IP traffic going to and from network interfaces in the VPC.
- **IPv6 Configuration**:
  - Assigned IPv6 addresses to the public subnet.
  - Added an Egress-Only Internet Gateway to allow outbound-only IPv6 traffic from the VPC to the internet.

## 🧠 Additional Notes

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

## ⚠️ Skipped Exercises

- **NAT Instance**: Skipped the hands-on exercise involving NAT Instances, opting to use a NAT Gateway instead.
- **Network ACLs (NACLs)**: Skipped the NACL hands-on exercise, as it primarily involved experimenting with rule priorities.

## 📊 Resource Summary

- **Total AWS Resources Managed**: 64

---

This setup demonstrates a robust VPC configuration, incorporating both IPv4 and IPv6 addressing, secure access mechanisms, and efficient routing and logging practices, all managed through Terraform.
