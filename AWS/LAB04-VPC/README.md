# LAB04: Building a Complete VPC Network Architecture with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to create a complete **Amazon Virtual Private Cloud (VPC)** architecture that follows AWS best practices. You'll configure public, private, and database subnets across multiple availability zones, set up routing with Internet and NAT gateways, and implement network ACLs and security groups for proper network segmentation and security.

A well-designed VPC is the foundation of any cloud architecture, providing network isolation, security, and connectivity for your AWS resources. This lab will teach you how to use infrastructure as code to create a production-ready VPC design.

---

## 🎯 Learning Objectives

- Design and implement a multi-tier VPC architecture with Terraform
- Create properly configured subnets across multiple availability zones
- Configure route tables for public and private subnets
- Set up Internet Gateway and NAT Gateway for controlled internet access
- Implement network ACLs and security groups for defense-in-depth
- Configure VPC endpoints for secure access to AWS services (optional)
- Enable and configure VPC Flow Logs for network monitoring (optional)
- Understand VPC design best practices and considerations

---

## 🧰 Prerequisites

- AWS account with administrator access
- Terraform v1.3+ installed
- AWS CLI installed and configured
- Basic understanding of networking concepts (IP addressing, routing, subnets)

---

## 📁 Files Structure

```
AWS/LAB04-VPC/
├── main.tf                  # Main configuration with VPC resources
├── variables.tf             # Variable declarations
├── outputs.tf               # Output definitions
├── terraform.tfvars.example # Sample variable values (rename to terraform.tfvars to use)
└── README.md                # Lab instructions
```

---

## 🌐 VPC Architecture

This lab implements a 3-tier VPC architecture with the following components:

1. **Public Subnets**: For internet-facing resources like load balancers and bastion hosts
2. **Private Subnets**: For application servers and other protected resources
3. **Database Subnets**: For isolated database instances with no internet access
4. **Internet Gateway**: Provides internet access for public subnets
5. **NAT Gateway**: Allows private resources to initiate outbound internet connections
6. **Route Tables**: Control traffic flow between subnets and the internet
7. **Network ACLs**: Provide stateless filtering at the subnet level
8. **Security Groups**: Provide stateful filtering at the instance level

All of these resources are deployed across multiple availability zones (AZs) for high availability.

---

## 🚀 Lab Steps

### Step 1: Prepare Your Environment

1. Ensure AWS CLI is configured:
   ```bash
   aws configure
   # OR use environment variables:
   # export AWS_ACCESS_KEY_ID="your_access_key"
   # export AWS_SECRET_ACCESS_KEY="your_secret_key"
   # export AWS_DEFAULT_REGION="eu-west-1"
   ```

### Step 2: Initialize Terraform

1. Navigate to the lab directory:
   ```bash
   cd AWS/LAB04-VPC
   ```

2. Initialize Terraform to download provider plugins:
   ```bash
   terraform init
   ```

### Step 3: Configure VPC Settings

1. Create a `terraform.tfvars` file by copying the example:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Customize the configuration in `terraform.tfvars` to adjust CIDR blocks, region, etc.

   > ⚠️ **Important**: The NAT Gateway will incur costs even when idle. Set `create_nat_gateway = false` to avoid charges if you're concerned about costs.

### Step 4: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the VPC resources to be created:
   - VPC with DNS settings enabled
   - Three sets of subnets (public, private, database)
   - Internet Gateway and NAT Gateway
   - Route tables and associations
   - Network ACLs and rules
   - Security groups for different tiers
   - Optional VPC endpoints and flow logs

### Step 5: Create the VPC Infrastructure

1. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

2. Type `yes` when prompted to confirm

3. After successful application, Terraform will display outputs including:
   - VPC ID and CIDR block
   - Subnet IDs for each tier
   - Route table IDs
   - Security group IDs
   - Gateway IDs and IP addresses

### Step 6: Explore the VPC

1. View the VPC in the AWS Console:
   - Navigate to the VPC dashboard
   - Examine the subnets, route tables, and security groups

2. Validate the connectivity:
   ```bash
   # Check if the VPC exists
   aws ec2 describe-vpcs --vpc-id $(terraform output -raw vpc_id)
   
   # List subnets in the VPC
   aws ec2 describe-subnets --filter "Name=vpc-id,Values=$(terraform output -raw vpc_id)"
   
   # Check route tables
   aws ec2 describe-route-tables --filter "Name=vpc-id,Values=$(terraform output -raw vpc_id)"
   ```

---

## 🔍 Understanding the VPC Design

### Networking Diagram

```
                                   Internet
                                      |
                                      | 
                                Internet Gateway
                                      |
                                      |
+--------------------------------------------------------------------------+
|                                  VPC                                      |
|                                                                          |
|  +-----------------+  +-----------------+  +-----------------+           |
|  | Public Subnet A |  | Public Subnet B |  | Public Subnet C |           |
|  | 10.0.1.0/24     |  | 10.0.2.0/24     |  | 10.0.3.0/24     |           |
|  | (eu-west-1a)    |  | (eu-west-1b)    |  | (eu-west-1c)    |           |
|  +-----------------+  +-----------------+  +-----------------+           |
|          |                     |                   |                     |
|          |                NAT Gateway              |                     |
|          |                     |                   |                     |
|  +-----------------+  +-----------------+  +-----------------+           |
|  | Private Subnet A|  | Private Subnet B|  | Private Subnet C|           |
|  | 10.0.11.0/24    |  | 10.0.12.0/24    |  | 10.0.13.0/24    |           |
|  | (eu-west-1a)    |  | (eu-west-1b)    |  | (eu-west-1c)    |           |
|  +-----------------+  +-----------------+  +-----------------+           |
|          |                     |                   |                     |
|  +-----------------+  +-----------------+  +-----------------+           |
|  | Database Sub A  |  | Database Sub B  |  | Database Sub C  |           |
|  | 10.0.21.0/24    |  | 10.0.22.0/24    |  | 10.0.23.0/24    |           |
|  | (eu-west-1a)    |  | (eu-west-1b)    |  | (eu-west-1c)    |           |
|  +-----------------+  +-----------------+  +-----------------+           |
|                                                                          |
+--------------------------------------------------------------------------+
```

### Key Components Explained

1. **VPC**: A logically isolated section of the AWS cloud with a dedicated CIDR block (10.0.0.0/16)

2. **Subnets**: Subdivisions of the VPC CIDR block, each assigned to a specific availability zone
   - **Public Subnets**: Have direct route to the Internet Gateway
   - **Private Subnets**: Can access the internet via NAT Gateway
   - **Database Subnets**: Isolated with no direct internet access

3. **Route Tables**: Control traffic between subnets and to/from the internet
   - **Public Route Table**: Routes traffic to the Internet Gateway
   - **Private Route Table**: Routes outbound traffic through the NAT Gateway
   - **Database Route Table**: Contains only local routes

4. **Internet Gateway**: Allows resources in public subnets to connect to the internet

5. **NAT Gateway**: Allows resources in private subnets to initiate outbound connections to the internet while preventing inbound connections

6. **Security Groups**: Act as virtual firewalls for instances
   - **Public Security Group**: Allows inbound SSH, HTTP, and HTTPS from anywhere
   - **Private Security Group**: Allows connections only from within the VPC
   - **Database Security Group**: Allows database connections only from the private subnet

7. **Network ACLs**: Provide an additional layer of security at the subnet level

---

## 💡 Key Learning Points

1. **VPC Design Principles**:
   - Multi-AZ deployment for high availability
   - Proper network segmentation with public, private, and database tiers
   - Defense in depth with both NACLs and security groups

2. **VPC Networking Concepts**:
   - CIDR block allocation and subnet planning
   - Traffic routing between subnets and the internet
   - NAT Gateway for secure outbound connectivity

3. **Terraform Techniques**:
   - Using `count` with lists to create multiple similar resources
   - Conditional resource creation with count and ternary operators
   - Resource references and dependencies

4. **AWS Best Practices**:
   - Isolating database instances in dedicated subnets
   - Using NAT Gateway for controlled internet access
   - Limiting security group rules to least privilege

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Create a Transit Gateway**:
   Connect this VPC to another VPC using AWS Transit Gateway

2. **Implement VPC Peering**:
   Create another VPC and set up VPC peering between them

3. **Set Up a VPN Connection**:
   Configure a Site-to-Site VPN to connect your VPC to an on-premises network

4. **Implement More Restrictive NACLs**:
   Create detailed NACL rules for each subnet to enforce tighter network security

---

## 🧼 Cleanup

To avoid ongoing charges for the resources created in this lab:

1. First, check for any dependent resources that might be using the VPC:
   ```bash
   # Check for EC2 instances in the VPC
   aws ec2 describe-instances --filters "Name=vpc-id,Values=$(terraform output -raw vpc_id)" --query "Reservations[].Instances[].InstanceId"
   
   # Check for load balancers
   aws elbv2 describe-load-balancers --query "LoadBalancers[?VpcId=='$(terraform output -raw vpc_id)'].LoadBalancerArn"
   
   # Check for RDS instances
   aws rds describe-db-instances --query "DBInstances[?DBSubnetGroup.VpcId=='$(terraform output -raw vpc_id)'].DBInstanceIdentifier"
   ```

2. If there are dependent resources, you'll need to delete them first or use the AWS Console to identify and remove them.

3. When ready, destroy the VPC infrastructure:
   ```bash
   terraform destroy
   ```

4. Type `yes` when prompted to confirm.

5. Verify that all resources have been deleted:
   ```bash
   # Check if the VPC still exists
   aws ec2 describe-vpcs --vpc-id $(terraform output -raw vpc_id) 2>/dev/null || echo "VPC has been deleted"
   ```

6. Clean up local files (optional):
   ```bash
   # Remove Terraform state files and other generated files
   rm -rf .terraform* terraform.tfstate* terraform.tfvars
   ```

> ⚠️ **Important Note**: The NAT Gateway is a billable resource that incurs costs even when idle. Make sure to destroy it when you're done with the lab.

---

## 🚫 Common Errors and Troubleshooting

1. **CIDR Block Overlap**:
   ```
   Error: error creating VPC: InvalidParameterValue: The CIDR 'X.X.X.X/X' overlaps with the CIDR 'Y.Y.Y.Y/Y'
   ```
   **Solution**: Choose a different CIDR block for your VPC that doesn't overlap with existing VPCs.

2. **NAT Gateway Dependency Error**:
   ```
   Error: Error creating NAT Gateway: InvalidElasticIpID.NotFound: The elastic IP ID 'eipalloc-X' does not exist
   ```
   **Solution**: Ensure that the Elastic IP is created successfully before the NAT Gateway.

3. **Resource Limits**:
   ```
   Error: Error creating VPC: VpcLimitExceeded: The maximum number of VPCs has been reached.
   ```
   **Solution**: Delete unused VPCs or request a limit increase from AWS.

---

## 📚 Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
- [Terraform AWS VPC Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [AWS VPC Design Best Practices](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/introduction.html)
- [VPC Subnet Calculator](https://cidr.xyz/) - Helpful for planning subnet CIDR blocks

---

## 🚀 Next Lab

Proceed to [LAB05-ELB-ASG](../LAB05-ELB-ASG/) to learn how to deploy a scalable application using Elastic Load Balancing and Auto Scaling Groups in your VPC.

---

Happy Terraforming!