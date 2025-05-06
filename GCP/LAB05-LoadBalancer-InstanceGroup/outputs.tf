# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "load_balancer_ip" {
  description = "The global IP address of the load balancer"
  value       = google_compute_global_address.default.address
}

output "load_balancer_url" {
  description = "The URL to access the load balancer"
  value       = "http://${google_compute_global_address.default.address}"
}

output "instance_template_name" {
  description = "The name of the instance template"
  value       = google_compute_instance_template.default.name
}

output "instance_template_self_link" {
  description = "The self link of the instance template"
  value       = google_compute_instance_template.default.self_link
}

output "managed_instance_group_name" {
  description = "The name of the managed instance group"
  value       = google_compute_instance_group_manager.default.name
}

output "managed_instance_group_self_link" {
  description = "The self link of the managed instance group"
  value       = google_compute_instance_group_manager.default.instance_group
}

output "backend_service_name" {
  description = "The name of the backend service"
  value       = google_compute_backend_service.default.name
}

output "backend_service_self_link" {
  description = "The self link of the backend service"
  value       = google_compute_backend_service.default.self_link
}

output "curl_command" {
  description = "Command to curl the load balancer"
  value       = "curl -v http://${google_compute_global_address.default.address}"
}

output "gcloud_list_instances" {
  description = "Command to list instances in the managed instance group"
  value       = "gcloud compute instance-groups managed list-instances ${google_compute_instance_group_manager.default.name} --zone=${var.zone} --project=${var.project_id}"
}

output "gcloud_describe_lb" {
  description = "Command to describe the load balancer forwarding rule"
  value       = "gcloud compute forwarding-rules describe ${google_compute_global_forwarding_rule.default.name} --global --project=${var.project_id}"
}

output "gcloud_resize_mig" {
  description = "Command to manually resize the managed instance group"
  value       = "gcloud compute instance-groups managed resize ${google_compute_instance_group_manager.default.name} --size=NUM_REPLICAS --zone=${var.zone} --project=${var.project_id}"
} 
