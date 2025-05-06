# LAB04: VPC Networks and Firewall Rules Solutions

This document provides solutions for the VPC Networks and Firewall Rules lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a custom VPC network
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  description             = "Custom VPC network created with Terraform"
  
  labels = var.labels
}

# Create a custom subnet within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
  
  private_ip_google_access = true
  
  description = "Custom subnet in ${var.region} with CIDR ${var.subnet_cidr}"
}

# Create a firewall rule for SSH access
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.id
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = var.allowed_ssh_ips
  target_tags   = var.ssh_target_tags
  priority      = 1000
  
  description = "Allow SSH access from specified IP ranges"
}

# Create a firewall rule for HTTP/HTTPS access
resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.vpc_name}-allow-http-https"
  network = google_compute_network.vpc.id
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.web_target_tags
  priority      = 1000
  
  description = "Allow HTTP and HTTPS access from anywhere"
}

# Create a firewall rule for internal traffic
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.id
  
  allow {
    protocol = "tcp"
  }
  
  allow {
    protocol = "udp"
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = [var.subnet_cidr]
  priority      = 900
  
  description = "Allow all internal traffic within the subnet"
}

# Create an egress firewall rule (optional)
resource "google_compute_firewall" "restrict_egress" {
  count = var.enable_egress_rule ? 1 : 0
  
  name      = "${var.vpc_name}-restrict-egress"
  network   = google_compute_network.vpc.id
  direction = "EGRESS"
  
  # Deny all traffic
  deny {
    protocol = "all"
  }
  
  # This rule applies to all instances 
  # (no target_tags means it applies to all instances in the network)
  
  # Destination ranges (everything)
  destination_ranges = ["0.0.0.0/0"]
  priority           = 1000
  
  description = "Deny all egress traffic by default"
}

# Allow specific egress destinations (if egress restriction is enabled)
resource "google_compute_firewall" "allow_specific_egress" {
  count = var.enable_egress_rule ? 1 : 0
  
  name      = "${var.vpc_name}-allow-specific-egress"
  network   = google_compute_network.vpc.id
  direction = "EGRESS"
  
  allow {
    protocol = "all"
  }
  
  destination_ranges = var.allowed_egress_destinations
  priority           = 900
  
  description = "Allow egress traffic to specific destinations"
}
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}
```

This configures the Google Cloud provider with your project ID and region, which are passed from variables to allow flexibility across different environments.

### 2. Create a Custom VPC Network

```terraform
resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  description             = "Custom VPC network created with Terraform"
  
  labels = var.labels
}
```

This creates a custom VPC network with:

- **name**: A custom name from the variables
- **auto_create_subnetworks**: Set to false to prevent automatic subnet creation (we'll create our own)
- **description**: A human-readable description of the network
- **labels**: Key-value pairs for organization and cost tracking

Setting `auto_create_subnetworks` to false gives you control over subnet CIDR ranges and regions.

### 3. Create a Custom Subnet

```terraform
resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.subnet_cidr
  
  private_ip_google_access = true
  
  description = "Custom subnet in ${var.region} with CIDR ${var.subnet_cidr}"
}
```

This creates a subnet within your VPC with:

- **name**: A custom name from the variables
- **region**: The GCP region for this subnet
- **network**: The parent VPC network
- **ip_cidr_range**: The IP range for this subnet (e.g., 10.0.0.0/24)
- **private_ip_google_access**: Allows instances without external IPs to access Google APIs
- **description**: Details about the subnet's location and CIDR range

### 4. Create a Firewall Rule for SSH Access

```terraform
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.id
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = var.allowed_ssh_ips
  target_tags   = var.ssh_target_tags
  priority      = 1000
  
  description = "Allow SSH access from specified IP ranges"
}
```

This creates a firewall rule allowing SSH access with:

- **name**: A descriptive name based on the VPC name
- **network**: The VPC network where this rule applies
- **allow**: TCP traffic on port 22 (SSH)
- **source_ranges**: IP ranges allowed to connect via SSH
- **target_tags**: Only instances with these tags will allow SSH
- **priority**: Lower numbers have higher priority (1000 is a standard priority)

### 5. Create a Firewall Rule for HTTP/HTTPS Access

```terraform
resource "google_compute_firewall" "allow_http_https" {
  name    = "${var.vpc_name}-allow-http-https"
  network = google_compute_network.vpc.id
  
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.web_target_tags
  priority      = 1000
  
  description = "Allow HTTP and HTTPS access from anywhere"
}
```

This creates a firewall rule for web traffic with:

- **allow**: TCP traffic on ports 80 (HTTP) and 443 (HTTPS)
- **source_ranges**: Traffic from any IP address
- **target_tags**: Only instances with these tags will accept web traffic

### 6. Create a Firewall Rule for Internal Traffic

```terraform
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.vpc_name}-allow-internal"
  network = google_compute_network.vpc.id
  
  allow {
    protocol = "tcp"
  }
  
  allow {
    protocol = "udp"
  }
  
  allow {
    protocol = "icmp"
  }
  
  source_ranges = [var.subnet_cidr]
  priority      = 900
  
  description = "Allow all internal traffic within the subnet"
}
```

This creates a firewall rule for internal communication with:

- **allow**: All TCP, UDP, and ICMP traffic
- **source_ranges**: Only traffic originating from within the subnet
- **priority**: 900 (higher priority than the other rules)

This allows instances within the subnet to communicate freely with each other.

### 7. Create Egress Firewall Rules (Optional)

```terraform
resource "google_compute_firewall" "restrict_egress" {
  count = var.enable_egress_rule ? 1 : 0
  
  name      = "${var.vpc_name}-restrict-egress"
  network   = google_compute_network.vpc.id
  direction = "EGRESS"
  
  # Deny all traffic
  deny {
    protocol = "all"
  }
  
  # Destination ranges (everything)
  destination_ranges = ["0.0.0.0/0"]
  priority           = 1000
  
  description = "Deny all egress traffic by default"
}

resource "google_compute_firewall" "allow_specific_egress" {
  count = var.enable_egress_rule ? 1 : 0
  
  name      = "${var.vpc_name}-allow-specific-egress"
  network   = google_compute_network.vpc.id
  direction = "EGRESS"
  
  allow {
    protocol = "all"
  }
  
  destination_ranges = var.allowed_egress_destinations
  priority           = 900
  
  description = "Allow egress traffic to specific destinations"
}
```

These create conditional egress firewall rules that:

- Only get created if `enable_egress_rule` is true (using the count parameter)
- First deny all outbound traffic
- Then specifically allow traffic to certain destinations (like Google APIs)
- Use priorities to ensure the allow rule takes precedence (900 vs 1000)

This implements a zero-trust model for outbound traffic.

## Variables and Outputs

### Important Variables

- **vpc_name** and **subnet_name**: Define the names of your network resources
- **subnet_cidr**: The IP range for your subnet
- **allowed_ssh_ips**: Restrict SSH access to specific IPs
- **ssh_target_tags** and **web_target_tags**: Network tags to control which instances get which rules

### Key Outputs

- **vpc_id** and **subnet_id**: Resource identifiers
- **firewall_names**: Names of created firewall rules
- **gcloud commands**: Ready-to-use commands for verification

## Common Issues and Solutions

1. **VPC already exists**: VPC names must be unique within the project
2. **CIDR range conflicts**: Make sure your subnet CIDR doesn't overlap with other subnets
3. **Firewall rule conflicts**: Check for existing rules with the same name
4. **Connectivity issues**: Verify that instance tags match the firewall rule target tags

## Advanced Customizations

For more complex deployments, consider:

1. Adding secondary IP ranges for GKE:
```terraform
secondary_ip_range {
  range_name    = "pods"
  ip_cidr_range = "10.1.0.0/16"
}

secondary_ip_range {
  range_name    = "services"
  ip_cidr_range = "10.2.0.0/16"
}
```

2. Setting up VPC peering:
```terraform
resource "google_compute_network_peering" "peering" {
  name                 = "peering-network"
  network              = google_compute_network.vpc.id
  peer_network         = "projects/other-project/global/networks/other-vpc"
  export_custom_routes = true
  import_custom_routes = true
}
```

3. Implementing shared VPC:
```terraform
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id
}

resource "google_compute_shared_vpc_service_project" "service" {
  host_project    = var.host_project_id
  service_project = var.service_project_id
}
``` 