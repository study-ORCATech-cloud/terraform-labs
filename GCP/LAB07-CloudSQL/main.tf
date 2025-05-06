provider "google" {
  # TODO: Configure the Google Cloud provider
  # Requirements:
  # - Set the project ID using var.project_id
  # - Set the region using var.region
}

# TODO: Enable the Cloud SQL Admin API
# Requirements:
# - Use the google_project_service resource
# - Enable "sqladmin.googleapis.com"
# - Disable service on destroy
# - Skip waiting for the API to be enabled on the first run

# TODO: Create a PostgreSQL Cloud SQL instance
# Requirements:
# - Use google_sql_database_instance resource
# - Set name using var.instance_name
# - Set database version to POSTGRES_14
# - Configure settings block with tier and availability type
# - Set deletion_protection to false for lab purposes
# - Configure backup settings if var.enable_backups is true
# - Add appropriate labels for resource tracking

# TODO: Configure Private IP (if var.enable_private_ip is true)
# Requirements:
# - Use private_network attribute in the settings block
# - Reference a VPC network ID from var.network_id
# - Configure ipv4_enabled = false when using private IP

# TODO: Configure Public IP (if var.enable_private_ip is false)
# Requirements:
# - Create an ip_configuration block within settings
# - Enable ipv4
# - Add authorized networks from var.authorized_networks

# TODO: Set database flags (optional)
# Requirements:
# - Create database_flags blocks for PostgreSQL settings
# - Set appropriate values for performance and security
# - Common flags include: max_connections, shared_buffers, etc.

# TODO: Create a database
# Requirements:
# - Use google_sql_database resource
# - Set the name using var.db_name
# - Use default charset and collation

# TODO: Create a user for database access
# Requirements:
# - Use google_sql_user resource
# - Create a user with var.db_username
# - Set password using var.db_password
# - Set appropriate user type (BUILT_IN recommended for lab) 
