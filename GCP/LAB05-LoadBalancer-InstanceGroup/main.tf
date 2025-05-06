provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Create a basic HTTP health check
# Requirements:
# - Create a compute health check for HTTP
# - Set an appropriate name with var.name_prefix
# - Configure the check to query the "/" path on port 80
# - Set appropriate intervals and timeouts
# - Add appropriate description

# TODO: Create an instance template for the MIG
# Requirements:
# - Name the template using var.name_prefix
# - Use var.machine_type for the machine type (e.g., e2-medium)
# - Use var.image for the boot disk image
# - Add appropriate network tags for HTTP and SSH access
# - Configure a startup script to install Apache/Nginx and serve a basic webpage
# - Configure the network interface to use the default network

# TODO: Create a managed instance group
# Requirements:
# - Name the MIG using var.name_prefix
# - Set the zone using var.zone
# - Use the instance template created earlier
# - Set the target size to var.instance_count
# - Configure named ports (e.g., http:80)
# - Configure autoscaling if var.enable_autoscaling is true
# - Set appropriate min/max replicas and cooldown periods

# TODO: Create a backend service
# Requirements:
# - Name the backend service using var.name_prefix
# - Associate it with the health check created earlier
# - Configure an appropriate protocol (HTTP)
# - Set timeout and connection draining timeout
# - Configure backends to include the MIG with appropriate parameters

# TODO: Create a URL map
# Requirements:
# - Name the URL map using var.name_prefix
# - Set the default service to the backend service created earlier

# TODO: Create an HTTP proxy
# Requirements:
# - Name the HTTP proxy using var.name_prefix
# - Connect it to the URL map created earlier

# TODO: Create a global forwarding rule
# Requirements:
# - Name the forwarding rule using var.name_prefix
# - Set the IP address to a new global address
# - Connect it to the HTTP target proxy
# - Configure the correct ports (80) 
