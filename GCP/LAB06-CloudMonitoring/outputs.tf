# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "monitoring_api_status" {
  description = "Status of the Cloud Monitoring API"
  value       = "Enabled (${google_project_service.monitoring_api.service})"
}

output "logging_api_status" {
  description = "Status of the Cloud Logging API"
  value       = "Enabled (${google_project_service.logging_api.service})"
}

output "cpu_alert_policy_name" {
  description = "Name of the CPU utilization alert policy"
  value       = google_monitoring_alert_policy.cpu_utilization.name
}

output "network_alert_policy_name" {
  description = "Name of the network egress alert policy"
  value       = google_monitoring_alert_policy.network_egress.name
}

output "dashboard_url" {
  description = "URL to access the monitoring dashboard"
  value       = "https://console.cloud.google.com/monitoring/dashboards/custom/${substr(google_monitoring_dashboard.dashboard.id, length("projects/${var.project_id}/dashboards/"), -1)}"
}

output "logs_sink_name" {
  description = "Name of the log sink"
  value       = google_logging_project_sink.vm_logs.name
}

output "logs_sink_destination" {
  description = "Destination for the log sink"
  value       = google_logging_project_sink.vm_logs.destination
}

output "logs_bucket_name" {
  description = "Name of the logs storage bucket (if created)"
  value       = var.create_logs_bucket ? google_storage_bucket.logs_bucket[0].name : "No storage bucket created"
}

output "bigquery_dataset_id" {
  description = "BigQuery dataset ID for logs (if created)"
  value       = var.create_logs_bigquery ? google_bigquery_dataset.logs_dataset[0].dataset_id : "No BigQuery dataset created"
}

output "console_monitoring_url" {
  description = "URL to access Google Cloud Monitoring"
  value       = "https://console.cloud.google.com/monitoring?project=${var.project_id}"
}

output "console_logging_url" {
  description = "URL to access Google Cloud Logging"
  value       = "https://console.cloud.google.com/logs/query?project=${var.project_id}"
} 
