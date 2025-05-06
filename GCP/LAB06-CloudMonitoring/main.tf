provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Enable the Cloud Monitoring API
# Requirements:
# - Use the google_project_service resource
# - Enable "monitoring.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Enable the Cloud Logging API
# Requirements:
# - Use the google_project_service resource
# - Enable "logging.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Create a CPU utilization alert policy
# Requirements:
# - Create a threshold-based alert policy
# - Use the "compute.googleapis.com/instance/cpu/utilization" metric
# - Set threshold value to var.cpu_threshold (e.g., 0.8 for 80%)
# - Set condition duration to var.alert_duration
# - Configure appropriate alert policy display name and documentation
# - Use notification_channels from var.notification_channels if provided

# TODO: Create a Network egress alert policy
# Requirements:
# - Create a threshold-based alert policy for network egress
# - Use the "compute.googleapis.com/instance/network/sent_bytes_count" metric
# - Set threshold value to var.network_threshold
# - Set condition duration to var.alert_duration
# - Configure appropriate alert policy display name and documentation
# - Use notification_channels from var.notification_channels if provided

# TODO: Create a basic dashboard
# Requirements:
# - Create a dashboard with var.dashboard_name
# - Add tiles for CPU utilization and network egress
# - Use appropriate display names and descriptions

# TODO: Create a Log Sink for VM instances
# Requirements:
# - Create a log sink to export VM instance logs
# - Use filter to include only compute.googleapis.com instance logs
# - Send logs to a Cloud Storage bucket (if var.create_logs_bucket is true)
# - Alternatively, send logs to BigQuery (if var.create_logs_bigquery is true)

# TODO: (Optional) Create a Cloud Storage bucket for logs if var.create_logs_bucket is true
# Requirements:
# - Use count or dynamic blocks for conditional creation
# - Set appropriate storage class, location, and lifecycle policies
# - Add appropriate labels for cost management 
