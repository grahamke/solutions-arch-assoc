# Storage Extras

This directory contains notes and use cases for additional AWS storage services covered in the AWS Solutions Architect Associate course.

## Overview

This section covers advanced AWS storage services and data transfer solutions that are important for the SAA-C03 exam. No hands-on labs are included, but comprehensive notes on key services and their use cases are provided.

## Topics Covered (Theory Only)

### AWS Snow Family

Data transfer and edge computing devices for moving large amounts of data to/from AWS:

**Snowball Edge Storage Optimized**
- 80 TB HDD capacity
- Use cases: Large data migrations, content distribution, backup to cloud
- Exam focus: When to use vs. other Snow devices

**Snowball Edge Compute Optimized** 
- 42 TB HDD + 7.68 TB NVMe SSD
- EC2 instances and Lambda functions at edge
- Use cases: Data preprocessing, machine learning at edge, IoT data collection

**Snowcone**
- 8 TB HDD storage
- Smallest Snow device, battery-powered
- Use cases: Edge locations, harsh environments, space-constrained deployments
- Can work with AWS DataSync

**Snowmobile**
- Up to 100 PB capacity
- Exabyte-scale data transfer
- Use cases: Data center shutdowns, massive cloud migrations

### AWS FSx

Fully managed file systems for various workloads:

**FSx for Windows File Server**
- SMB protocol support
- Active Directory integration
- Use cases: Windows-based applications, file shares, home directories
- Exam focus: When to choose over EFS

**FSx for Lustre**
- High-performance computing (HPC) workloads for Linux Cluster (Lustre)
- Sub-millisecond latencies
- Use cases: Machine learning, analytics, video processing
- Integration with S3 for data lakes

**FSx for NetApp ONTAP**
- Multi-protocol support (NFS, SMB, iSCSI)
- Data deduplication and compression
- Use cases: Enterprise applications, database workloads

**FSx for OpenZFS**
- Point-in-time snapshots
- Data compression
- Use cases: Linux-based workloads requiring high performance

### AWS Storage Gateway

Hybrid cloud storage service connecting on-premises to AWS:

**File Gateway**
- NFS/SMB file shares backed by S3
- Use cases: File shares, content distribution, backup to cloud
- Local cache for frequently accessed data

**Volume Gateway - Stored Volumes**
- Primary data on-premises, async backup to S3 as EBS snapshots
- Use cases: Low-latency access to entire dataset on-premises
- 1 GB to 16 TB per volume

**Volume Gateway - Cached Volumes**
- Primary data in S3, cache frequently accessed data on-premises
- Use cases: Frequently accessed data on-premises, full dataset in S3
- Up to 32 TB per volume

**Tape Gateway (VTL)**
- Virtual Tape Library interface
- Use cases: Replace physical tape infrastructure
- Integration with existing backup software

### AWS Transfer Family

Managed file transfer services:

**AWS Transfer for SFTP**
- Secure File Transfer Protocol
- Use cases: B2B file exchanges, secure file transfers
- Integration with S3, EFS

**AWS Transfer for FTPS**
- File Transfer Protocol over SSL
- Use cases: Legacy application support
- Certificate-based authentication

**AWS Transfer for FTP**
- Standard File Transfer Protocol
- Use cases: Internal file transfers (not recommended for internet-facing)
- VPC endpoint only

**Common Features**
- Multi-protocol support on single endpoint
- Integration with existing authentication systems
- Managed scaling and availability

### AWS DataSync

Data transfer service for moving data between on-premises and AWS:

**Key Features**
- One-time or scheduled data transfer
- Bandwidth throttling and network optimization
- Data integrity verification
- Preserve file permissions and metadata

**DataSync Agent**
- VM deployed on-premises or in cloud
- Connects source and destination locations
- Handles data transfer optimization
- Required for on-premises to AWS transfers

**DataSync with Snowcone**
- Pre-installed DataSync agent on Snowcone device
- Use cases: Remote locations with limited connectivity
- Transfer data to Snowcone, then ship to AWS
- Automatic sync to S3 when connected to AWS

**Supported Locations**
- On-premises: NFS, SMB file systems
- AWS: S3, EFS, FSx for Windows File Server, FSx for Lustre
- Other cloud providers via NFS/SMB

## Exam Focus Areas

**Snow Family Selection**
- Data size and transfer time requirements
- Network bandwidth limitations
- Edge computing needs
- Cost considerations for different transfer methods

**FSx Service Selection**
- Protocol requirements (SMB, NFS, Lustre)
- Performance needs (throughput, IOPS, latency)
- Integration requirements (Active Directory, S3)
- Workload types (HPC, enterprise applications)

**Storage Gateway Use Cases**
- Hybrid cloud storage requirements
- Latency and bandwidth considerations
- Backup and archival strategies
- Protocol compatibility needs

**Transfer Family vs DataSync**
- Real-time vs batch data transfer
- Protocol requirements
- Authentication and security needs
- Integration with existing systems

**DataSync Deployment Options**
- Agent placement considerations
- Network connectivity requirements
- Snowcone integration scenarios
- Transfer scheduling and monitoring

## Important Notes

- Snow devices require physical shipping and handling
- FSx pricing varies significantly between file system types
- Storage Gateway requires on-premises VM deployment
- Transfer Family charges per protocol enabled and data transferred
- DataSync agent can be deployed on-premises, EC2, or comes pre-installed on Snowcone
- Consider bandwidth, latency, and cost when choosing data transfer methods

## Cost Considerations

- Snow Family: One-time device costs plus shipping
- FSx: Provisioned storage and throughput capacity charges
- Storage Gateway: Gateway usage and data transfer costs
- Transfer Family: Per-protocol and data transfer charges
- DataSync: Per-GB transferred pricing
