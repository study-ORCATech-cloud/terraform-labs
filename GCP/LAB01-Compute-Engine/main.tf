provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
  # - Set the zone using var.zone
}

# TODO: Create a Compute Engine VM instance
# Requirements:
# - Name the instance using var.instance_name
# - Set the machine type using var.machine_type (e.g., e2-medium)
# - Set the zone using var.zone
# - Configure the boot disk with an appropriate image (e.g., debian-cloud/debian-11)
# - Allow HTTP traffic by setting tags ["http-server"]
# - Set appropriate labels for identification (e.g., environment = "dev")
# - Configure SSH keys if you plan to connect via SSH

# TODO: Create a firewall rule to allow HTTP traffic to the instance
# Requirements:
# - Name the firewall rule appropriately
# - Allow TCP traffic on port 80
# - Set target tags to match the VM instance tags 
