provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Create a custom VPC network
# Requirements:
# - Use var.vpc_name for the network name
# - Set auto_create_subnetworks to false for custom subnet creation
# - Add appropriate description and labels

# TODO: Create a custom subnet within the VPC
# Requirements:
# - Use var.subnet_name for the subnet name
# - Set the region using var.region
# - Set the CIDR range using var.subnet_cidr
# - Set private_ip_google_access to true to allow private access to Google APIs

# TODO: Create a firewall rule for SSH access
# Requirements:
# - Allow SSH (TCP port 22) access
# - Restrict source IPs to var.allowed_ssh_ips
# - Target instances with network tags from var.ssh_target_tags
# - Set appropriate priority (e.g., 1000)

# TODO: Create a firewall rule for HTTP/HTTPS access
# Requirements:
# - Allow HTTP (TCP port 80) and HTTPS (TCP port 443) access
# - Allow from any source (0.0.0.0/0)
# - Target instances with network tags from var.web_target_tags
# - Set appropriate priority (e.g., 1000)

# TODO: Create a firewall rule for internal traffic
# Requirements:
# - Allow all internal traffic within the subnet
# - Use the CIDR range from var.subnet_cidr as the source range
# - Set appropriate priority (e.g., 900)

# TODO: (Optional) Create an egress firewall rule if var.enable_egress_rule is true
# Requirements:
# - Use count or dynamic blocks for conditional creation
# - Deny all outbound traffic except to Google APIs and specific domains
# - Set direction to EGRESS
# - Use appropriate priority (e.g., 1000) 
