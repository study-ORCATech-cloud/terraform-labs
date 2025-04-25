# LAB04: Building a Complete VPC Network Architecture with Terraform

## 📝 Lab Overview

In this lab, you'll use **Terraform** to create a complete **Amazon Virtual Private Cloud (VPC)** architecture that follows AWS best practices. You'll configure public, private, and database subnets across multiple availability zones, set up routing with Internet and NAT gateways, and implement network ACLs and security groups for proper network segmentation and security.

A well-designed VPC is the foundation of any cloud architecture, providing network isolation, security, and connectivity for your AWS resources. This lab will teach you how to use infrastructure as code to create a production-ready VPC design.

---

## 🎯 Learning Objectives

- Design and implement a multi-tier VPC architecture with Terraform
- Create subnets across multiple availability zones for high availability
- Configure route tables and routing for different subnet tiers
- Set up Internet Gateway for public internet access
- Implement NAT Gateway for secure outbound connectivity
- Create Network ACLs for stateless filtering at the subnet level
- Configure security groups for stateful traffic filtering at the instance level
- Set up VPC endpoints for secure access to AWS services (optional)
- Enable VPC Flow Logs for network traffic monitoring (optional)
- Apply AWS networking best practices in an infrastructure as code environment

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

### Step 4: Complete the TODO Sections

This lab contains several TODO sections that you need to complete:

1. In `main.tf`:
   - Create the VPC with DNS settings enabled
   - Create public, private, and database subnets across availability zones
   - Set up Internet Gateway and NAT Gateway (conditional)
   - Create route tables for each subnet tier
   - Configure routes for internet access
   - Associate subnets with appropriate route tables
   - Create Network ACLs for each subnet tier
   - Configure NACL rules for traffic filtering
   - Set up security groups for different instance types
   - Create VPC endpoint for S3 (conditional)
   - Set up VPC Flow Logs with CloudWatch integration (conditional)

2. In `outputs.tf`:
   - Define outputs for VPC attributes (ID, ARN, CIDR)
   - Output subnet IDs for each tier
   - Output route table IDs
   - Output gateway IDs
   - Create conditional outputs for optional resources

### Step 5: Review the Execution Plan

1. Generate and review an execution plan:
   ```bash
   terraform plan
   ```

2. The plan will show the VPC resources to be created:
   - VPC with DNS settings enabled
   - Three sets of subnets (public, private, database)
   - Internet Gateway and NAT Gateway (if enabled)
   - Route tables with appropriate routes
   - Network ACLs with inbound and outbound rules
   - Security groups with ingress and egress rules
   - VPC endpoints for AWS services (if enabled)
   - VPC Flow Logs with CloudWatch integration (if enabled)

### Step 6: Apply the Configuration

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
   - Endpoint IDs (if created)
   - Flow Logs details (if enabled)

### Step 7: Explore the VPC

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

3. Examine the network ACLs:
   ```bash
   # Get NACL details
   aws ec2 describe-network-acls --filter "Name=vpc-id,Values=$(terraform output -raw vpc_id)"
   ```

4. Check security groups:
   ```bash
   # List security groups
   aws ec2 describe-security-groups --filter "Name=vpc-id,Values=$(terraform output -raw vpc_id)"
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
   ```hcl
   resource "aws_vpc" "lab_vpc" {
     cidr_block           = var.vpc_cidr
     enable_dns_hostnames = true
     enable_dns_support   = true
     tags = {
       Name = "${var.name_prefix}-vpc"
       # Other tags...
     }
   }
   ```

2. **Subnets**: Subdivisions of the VPC CIDR block, each assigned to a specific availability zone
   ```hcl
   resource "aws_subnet" "public_subnets" {
     count                   = length(var.public_subnet_cidrs)
     vpc_id                  = aws_vpc.lab_vpc.id
     cidr_block              = var.public_subnet_cidrs[count.index]
     availability_zone       = element(var.availability_zones, count.index)
     map_public_ip_on_launch = true
     tags = {
       Name = "${var.name_prefix}-public-subnet-${count.index + 1}"
       Type = "Public"
     }
   }
   ```

3. **Route Tables**: Control traffic between subnets and to/from the internet
   ```hcl
   resource "aws_route_table" "public_route_table" {
     vpc_id = aws_vpc.lab_vpc.id
     tags = {
       Name = "${var.name_prefix}-public-rt"
       Type = "Public"
     }
   }
   
   resource "aws_route" "public_internet_route" {
     route_table_id         = aws_route_table.public_route_table.id
     destination_cidr_block = "0.0.0.0/0"
     gateway_id             = aws_internet_gateway.igw.id
   }
   ```

4. **Internet Gateway**: Provides public internet access for resources in public subnets
   ```hcl
   resource "aws_internet_gateway" "igw" {
     vpc_id = aws_vpc.lab_vpc.id
     tags = {
       Name = "${var.name_prefix}-igw"
     }
   }
   ```

5. **NAT Gateway**: Allows private resources to initiate outbound internet connections
   ```hcl
   resource "aws_nat_gateway" "nat_gateway" {
     count         = var.create_nat_gateway ? 1 : 0
     allocation_id = aws_eip.nat_eip[0].id
     subnet_id     = aws_subnet.public_subnets[0].id
     tags = {
       Name = "${var.name_prefix}-nat-gateway"
     }
     depends_on = [aws_internet_gateway.igw]
   }
   ```

6. **Network ACLs**: Provide subnet-level stateless traffic filtering
   ```hcl
   resource "aws_network_acl" "public_nacl" {
     vpc_id     = aws_vpc.lab_vpc.id
     subnet_ids = aws_subnet.public_subnets[*].id
     tags = {
       Name = "${var.name_prefix}-public-nacl"
       Type = "Public"
     }
   }
   
   resource "aws_network_acl_rule" "public_ingress" {
     count          = length(var.public_inbound_acl_rules)
     network_acl_id = aws_network_acl.public_nacl.id
     egress         = false
     rule_number    = var.public_inbound_acl_rules[count.index]["rule_number"]
     rule_action    = var.public_inbound_acl_rules[count.index]["rule_action"]
     protocol       = var.public_inbound_acl_rules[count.index]["protocol"]
     cidr_block     = lookup(var.public_inbound_acl_rules[count.index], "cidr_block", null)
     from_port      = lookup(var.public_inbound_acl_rules[count.index], "from_port", null)
     to_port        = lookup(var.public_inbound_acl_rules[count.index], "to_port", null)
   }
   ```

7. **Security Groups**: Provide instance-level stateful traffic filtering
   ```hcl
   resource "aws_security_group" "public_sg" {
     name        = "${var.name_prefix}-public-sg"
     description = "Security group for public instances"
     vpc_id      = aws_vpc.lab_vpc.id
     
     ingress {
       from_port   = 22
       to_port     = 22
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
       description = "Allow SSH from anywhere"
     }
     
     # Additional ingress rules...
     
     egress {
       from_port   = 0
       to_port     = 0
       protocol    = "-1"
       cidr_blocks = ["0.0.0.0/0"]
       description = "Allow all outbound traffic"
     }
   }
   ```

---

## 💡 Key Learning Points

1. **VPC Design Principles**:
   - Multi-AZ deployment for high availability and fault tolerance
   - Network segmentation with public, private, and database tiers
   - Defense in depth with multiple security layers (NACLs, security groups)
   - Controlled internet access through Internet and NAT gateways
   - Private connectivity to AWS services via VPC endpoints

2. **VPC Networking Concepts**:
   - CIDR block allocation and subnet planning
   - Routing fundamentals between subnets and gateways
   - Public vs. private subnets and their use cases
   - Stateless vs. stateful traffic filtering
   - Network traffic monitoring with flow logs

3. **Terraform Techniques**:
   - Using `count` with lists to create multiple similar resources
   - Conditional resource creation with count and ternary operators
   - Resource dependencies and explicit depends_on statements
   - Looping through resources with lookup functions for optional fields
   - Outputting resource attributes for reference

4. **AWS Networking Best Practices**:
   - Isolating sensitive resources in private subnets
   - Using NAT Gateway for secure outbound connectivity
   - Applying least privilege security group rules
   - Implementing multiple layers of traffic filtering
   - Designing for high availability across multiple AZs

---

## 🧪 Challenge Exercises

Ready to learn more? Try these extensions:

1. **Create a Transit Gateway**:
   Connect this VPC to another VPC using AWS Transit Gateway
   ```hcl
   resource "aws_ec2_transit_gateway" "tgw" {
     description = "Transit Gateway for connecting multiple VPCs"
     tags = {
       Name = "${var.name_prefix}-transit-gateway"
     }
   }
   
   resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
     subnet_ids         = aws_subnet.private_subnets[*].id
     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
     vpc_id             = aws_vpc.lab_vpc.id
     tags = {
       Name = "${var.name_prefix}-tgw-attachment"
     }
   }
   ```

2. **Implement VPC Peering**:
   Create another VPC and set up VPC peering between them
   ```hcl
   resource "aws_vpc" "secondary_vpc" {
     cidr_block = "172.16.0.0/16"
     tags = {
       Name = "${var.name_prefix}-secondary-vpc"
     }
   }
   
   resource "aws_vpc_peering_connection" "vpc_peering" {
     vpc_id        = aws_vpc.lab_vpc.id
     peer_vpc_id   = aws_vpc.secondary_vpc.id
     auto_accept   = true
     tags = {
       Name = "${var.name_prefix}-vpc-peering"
     }
   }
   ```

3. **Set Up a VPN Connection**:
   Configure a Site-to-Site VPN to connect your VPC to an on-premises network
   ```hcl
   resource "aws_vpn_gateway" "vpn_gateway" {
     vpc_id = aws_vpc.lab_vpc.id
     tags = {
       Name = "${var.name_prefix}-vpn-gateway"
     }
   }
   
   resource "aws_customer_gateway" "customer_gateway" {
     bgp_asn    = 65000
     ip_address = "203.0.113.1" # Replace with your on-premises router IP
     type       = "ipsec.1"
     tags = {
       Name = "${var.name_prefix}-customer-gateway"
     }
   }
   
   resource "aws_vpn_connection" "vpn_connection" {
     vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
     customer_gateway_id = aws_customer_gateway.customer_gateway.id
     type                = "ipsec.1"
     static_routes_only  = true
     tags = {
       Name = "${var.name_prefix}-vpn-connection"
     }
   }
   ```

4. **Implement More Restrictive NACLs**:
   Create detailed NACL rules for each subnet to enforce tighter network security
   ```hcl
   # Create more specific rules for database tier
   resource "aws_network_acl_rule" "database_ingress_mysql" {
     network_acl_id = aws_network_acl.database_nacl.id
     rule_number    = 100
     egress         = false
     protocol       = "tcp"
     rule_action    = "allow"
     cidr_block     = var.vpc_cidr
     from_port      = 3306
     to_port        = 3306
   }
   
   resource "aws_network_acl_rule" "database_deny_all_other_ingress" {
     network_acl_id = aws_network_acl.database_nacl.id
     rule_number    = 200
     egress         = false
     protocol       = -1
     rule_action    = "deny"
     cidr_block     = "0.0.0.0/0"
     from_port      = 0
     to_port        = 0
   }
   ```

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
   **Solution**: Ensure that the Elastic IP is created successfully before the NAT Gateway. Add explicit depends_on.

3. **Resource Limits**:
   ```
   Error: Error creating VPC: VpcLimitExceeded: The maximum number of VPCs has been reached.
   ```
   **Solution**: Delete unused VPCs or request a limit increase from AWS.

4. **Subnet Conflicts**:
   ```
   Error: Error creating subnet: InvalidSubnet.Conflict: The CIDR 'X.X.X.X/X' conflicts with another subnet
   ```
   **Solution**: Choose non-overlapping CIDR blocks for your subnets.

5. **Missing Route Table Association**:
   ```
   Error: NoSuchRouteTable: The routeTable ID 'rtb-X' does not exist
   ```
   **Solution**: Ensure route tables are created before associating them with subnets.

---

## 📚 Additional Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
- [Terraform AWS VPC Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [AWS VPC Design Best Practices](https://docs.aws.amazon.com/whitepapers/latest/aws-vpc-connectivity-options/introduction.html)
- [VPC Subnet Calculator](https://cidr.xyz/) - Helpful for planning subnet CIDR blocks
- [AWS Networking Blog](https://aws.amazon.com/blogs/networking-and-content-delivery/)
- [AWS Architecture Center - VPC Design Patterns](https://aws.amazon.com/architecture/networking-connectivity/)

---

## 🚀 Next Lab

Proceed to [LAB05-ELB-ASG](../LAB05-ELB-ASG/) to learn how to deploy a scalable application using Elastic Load Balancing and Auto Scaling Groups in your VPC.

---

Happy Terraforming!