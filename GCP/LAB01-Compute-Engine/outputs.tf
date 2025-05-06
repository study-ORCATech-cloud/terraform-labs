# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "instance_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.vm_instance.name
}

output "instance_external_ip" {
  description = "External IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "instance_zone" {
  description = "Zone where the VM instance is deployed"
  value       = google_compute_instance.vm_instance.zone
}

output "instance_machine_type" {
  description = "Machine type of the VM instance"
  value       = google_compute_instance.vm_instance.machine_type
}

output "ssh_command" {
  description = "Command to SSH into the VM instance"
  value       = "ssh ${var.ssh_username}@${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip}"
} 
