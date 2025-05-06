# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.vpc.id
}

output "vpc_self_link" {
  description = "The self link of the VPC"
  value       = google_compute_network.vpc.self_link
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_self_link" {
  description = "The self link of the subnet"
  value       = google_compute_subnetwork.subnet.self_link
}

output "subnet_cidr" {
  description = "The CIDR range of the subnet"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

output "ssh_firewall_name" {
  description = "The name of the SSH firewall rule"
  value       = google_compute_firewall.allow_ssh.name
}

output "http_firewall_name" {
  description = "The name of the HTTP/HTTPS firewall rule"
  value       = google_compute_firewall.allow_http_https.name
}

output "internal_firewall_name" {
  description = "The name of the internal firewall rule"
  value       = google_compute_firewall.allow_internal.name
}

output "egress_firewall_name" {
  description = "The name of the egress firewall rule (if created)"
  value       = var.enable_egress_rule ? google_compute_firewall.restrict_egress[0].name : "No egress rule created"
}

output "gcloud_list_networks" {
  description = "Command to list networks"
  value       = "gcloud compute networks list --project=${var.project_id}"
}

output "gcloud_list_subnetworks" {
  description = "Command to list subnetworks"
  value       = "gcloud compute networks subnets list --project=${var.project_id}"
}

output "gcloud_list_firewall_rules" {
  description = "Command to list firewall rules"
  value       = "gcloud compute firewall-rules list --project=${var.project_id}"
}

output "example_vm_creation" {
  description = "Example command to create a VM in this network"
  value       = "gcloud compute instances create example-vm --project=${var.project_id} --zone=${var.region}-a --machine-type=e2-medium --subnet=${google_compute_subnetwork.subnet.name} --tags=${join(",", var.ssh_target_tags)},${join(",", var.web_target_tags)}"
}
