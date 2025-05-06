# NOTE: These outputs reference resources that you need to implement in main.tf 
# After completing all the TODOs in main.tf, these outputs will work correctly.
# DO NOT modify this file until you've implemented the required resources.

output "instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.postgres.name
}

output "instance_connection_name" {
  description = "Connection name for the Cloud SQL instance"
  value       = google_sql_database_instance.postgres.connection_name
}

output "instance_ip_address" {
  description = "IP address of the Cloud SQL instance"
  value       = var.enable_private_ip ? "Private IP: ${google_sql_database_instance.postgres.private_ip_address}" : "Public IP: ${google_sql_database_instance.postgres.public_ip_address}"
}

output "database_name" {
  description = "Name of the created database"
  value       = google_sql_database.database.name
}

output "database_user" {
  description = "Name of the database user"
  value       = google_sql_user.user.name
}

output "connection_string" {
  description = "PostgreSQL connection string (password not included)"
  value       = "postgresql://${google_sql_user.user.name}@${google_sql_database_instance.postgres.public_ip_address}:5432/${google_sql_database.database.name}"
}

output "console_url" {
  description = "URL to access the Cloud SQL instance in the console"
  value       = "https://console.cloud.google.com/sql/instances/${google_sql_database_instance.postgres.name}/overview?project=${var.project_id}"
}

output "connection_instructions" {
  description = "Instructions for connecting to the database"
  value       = var.enable_private_ip ? "Connect using the private IP from a VM in the same network or using Cloud SQL Proxy" : "Connect using the public IP from an authorized network or using Cloud SQL Proxy"
} 
