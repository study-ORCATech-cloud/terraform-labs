output "network_id" {
  description = "ID of the created VPC network"
  value       = google_compute_network.vpc_network.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "firewall_id" {
  description = "ID of the created firewall rule"
  value       = google_compute_firewall.firewall.id
} 
