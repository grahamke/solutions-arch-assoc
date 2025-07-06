# Amazon Route 53

This directory contains Terraform configurations for AWS Route 53 covered in the Solutions Architect Associate course.

## Overview

The configuration demonstrates how to set up and use Amazon Route 53 for DNS management, including:
- Working with hosted zones
- Creating various DNS record types
- Implementing health checks
- Configuring different routing policies

## Components

### 1. Hosted Zone Reference
- References an existing hosted zone for the domain
- Demonstrates how to work with existing DNS configurations

### 2. DNS Record Types
- A records for direct IP mapping
- CNAME records for domain name aliases
- Alias records for AWS resources (ALB)
- Apex domain configuration

### 3. EC2 Support Infrastructure
- Multi-region EC2 instances (eu-central-1, us-east-1, ap-southeast-1)
- Application Load Balancer setup
- Security groups and networking configuration
- Simple web server deployment via user data

### 4. Health Checks
- HTTP health checks for each EC2 instance
- Calculated health check combining multiple endpoints
- Integration with routing policies

### 5. Routing Policies
- **Simple Routing**: Basic DNS resolution with multiple values
- **Weighted Routing**: Traffic distribution based on assigned weights
- **Latency-Based Routing**: Directs traffic to the region with lowest latency
- **Failover Routing**: Primary/secondary configuration with health check integration
- **Geolocation Routing**: Routes based on user's geographic location
- **Multivalue Answer Routing**: Returns multiple healthy records for client-side load balancing

## Key Concepts Demonstrated

### DNS Management
- DNS record management
- TTL configuration and implications

### Health Checks
- Endpoint monitoring
- Failure thresholds and request intervals
- Calculated health checks for complex scenarios

### Routing Policies
- Traffic management strategies
- Regional and global distribution patterns
- Failover and high availability configurations

## Variables

| Name                 | Description                                | Default                       |
|----------------------|--------------------------------------------|-------------------------------|
| `region`             | AWS region to deploy resources             | -                             |
| `profile`            | AWS CLI profile to use                     | -                             |
| `hosted_zone_id`     | The hosted zone ID to use                  | -                             |
| `domain_name`        | Domain name to use                         | example-learning.com          |
| `eu_central_1_ami`   | AMI ID for EC2 instances in EU Central 1   | -                             |
| `us_east_1_ami`      | AMI ID for EC2 instances in US East 1      | -                             |
| `ap_southeast_1_ami` | AMI ID for EC2 instances in AP Southeast 1 | -                             |

## Outputs

| Name                         | Description                                          |
|------------------------------|------------------------------------------------------|
| `eu_central_ec2_public_ip`   | Public IP address of the EU Central 1 EC2 instance   |
| `us-east_ec2_public_ip`      | Public IP address of the US East 1 EC2 instance      |
| `ap-southeast_ec2_public_ip` | Public IP address of the AP Southeast 1 EC2 instance |
| `alb_dns`                    | DNS name of the Application Load Balancer            |

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Apply the configuration:
   ```
   terraform apply
   ```

3. Test the different routing policies by accessing the various subdomains:
   ```
   simple.example-learning.com
   weighted.example-learning.com
   latency.example-learning.com
   failover.example-learning.com
   geo.example-learning.com
   multi.example-learning.com
   ```

4. Clean up:
   ```
   terraform destroy
   ```

## Testing Routing Policies

To observe the different routing behaviors:

1. **Simple Routing**: DNS client receives all IPs and chooses one
2. **Weighted Routing**: Traffic is distributed according to weights (10%, 70%, 20%)
3. **Latency-Based**: Connect from different regions to see traffic routed to closest region
4. **Failover**: Stop the primary instance to see traffic route to secondary
5. **Geolocation**: Connect from different countries/continents to see appropriate routing
6. **Multivalue Answer**: Similar to simple routing but with health checks