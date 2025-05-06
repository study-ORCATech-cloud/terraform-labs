# LAB07: Cloud SQL PostgreSQL Solutions

This document provides solutions for the Cloud SQL PostgreSQL lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable the Cloud SQL Admin API
resource "google_project_service" "sqladmin_api" {
  service                    = "sqladmin.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Create a PostgreSQL Cloud SQL instance
resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier              = var.machine_tier
    availability_type = var.availability_type

    # IP Configuration
    dynamic "ip_configuration" {
      for_each = var.enable_private_ip ? [] : [1]
      content {
        ipv4_enabled    = true
        require_ssl     = true
        
        dynamic "authorized_networks" {
          for_each = var.authorized_networks
          content {
            name  = authorized_networks.value.name
            value = authorized_networks.value.value
          }
        }
      }
    }

    # Private IP Configuration (if enabled)
    dynamic "ip_configuration" {
      for_each = var.enable_private_ip ? [1] : []
      content {
        ipv4_enabled    = false
        private_network = var.network_id
        require_ssl     = true
      }
    }

    # Database flags
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    # Backup configuration (if enabled)
    dynamic "backup_configuration" {
      for_each = var.enable_backups ? [1] : []
      content {
        enabled                        = true
        start_time                     = var.backup_start_time
        point_in_time_recovery_enabled = true
        transaction_log_retention_days = var.backup_retention_days
        backup_retention_settings {
          retained_backups = var.backup_retention_days
          retention_unit   = "COUNT"
        }
      }
    }

    # Resource labels
    user_labels = var.labels
  }

  # Allow Terraform to destroy the instance
  deletion_protection = false

  depends_on = [google_project_service.sqladmin_api]
}

# Create a database
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}

# Create a user for database access
resource "google_sql_user" "user" {
  name     = var.db_username
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
  type     = "BUILT_IN"
}
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}
```

This configures the Google Cloud provider with your project ID and region. Using variables allows flexibility across different environments.

### 2. Enable Required API

```terraform
resource "google_project_service" "sqladmin_api" {
  service                    = "sqladmin.googleapis.com"
  disable_on_destroy         = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}
```

This enables the Cloud SQL Admin API which is required to create and manage Cloud SQL instances. The resource:
- Specifies the API service to enable
- Sets `disable_on_destroy` to true to disable the API when you run `terraform destroy`
- Sets custom timeouts to allow for API activation, which can take time
- Disables dependent services when destroying to prevent orphaned resources

### 3. Create a PostgreSQL Cloud SQL Instance

```terraform
resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier              = var.machine_tier
    availability_type = var.availability_type
    
    # ... other settings ...
  }

  deletion_protection = false

  depends_on = [google_project_service.sqladmin_api]
}
```

This creates a Cloud SQL instance running PostgreSQL 14. The resource:
- Sets the instance name and PostgreSQL version
- Configures the region for the instance
- Specifies the machine tier (e.g., "db-f1-micro" for development or "db-n1-standard-1" for production)
- Sets the availability type (ZONAL for single zone or REGIONAL for high availability)
- Disables deletion protection to allow Terraform to destroy the instance
- Depends on the SQL Admin API being enabled

### 4. Configure Network Access

For public IP access:

```terraform
dynamic "ip_configuration" {
  for_each = var.enable_private_ip ? [] : [1]
  content {
    ipv4_enabled    = true
    require_ssl     = true
    
    dynamic "authorized_networks" {
      for_each = var.authorized_networks
      content {
        name  = authorized_networks.value.name
        value = authorized_networks.value.value
      }
    }
  }
}
```

For private IP access:

```terraform
dynamic "ip_configuration" {
  for_each = var.enable_private_ip ? [1] : []
  content {
    ipv4_enabled    = false
    private_network = var.network_id
    require_ssl     = true
  }
}
```

The configuration:
- Uses dynamic blocks to conditionally set either public IP or private IP based on `var.enable_private_ip`
- For public IP, allows connections only from authorized networks
- For private IP, connects to a specified VPC network
- Enables SSL for secure connections in both cases

### 5. Set Database Flags

```terraform
dynamic "database_flags" {
  for_each = var.database_flags
  content {
    name  = database_flags.value.name
    value = database_flags.value.value
  }
}
```

This adds optional database flags for PostgreSQL configuration, such as:
- `max_connections`: Controls the maximum number of concurrent connections
- `shared_buffers`: Controls the amount of memory used for caching data

### 6. Configure Backups (Optional)

```terraform
dynamic "backup_configuration" {
  for_each = var.enable_backups ? [1] : []
  content {
    enabled                        = true
    start_time                     = var.backup_start_time
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = var.backup_retention_days
    backup_retention_settings {
      retained_backups = var.backup_retention_days
      retention_unit   = "COUNT"
    }
  }
}
```

This conditionally enables automated backups:
- Only creates the backup configuration if `var.enable_backups` is true
- Sets a start time for backups to run (in UTC)
- Enables point-in-time recovery for more granular restoration options
- Sets how many backups to retain based on the retention days variable

### 7. Create a Database and User

```terraform
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "user" {
  name     = var.db_username
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
  type     = "BUILT_IN"
}
```

These resources:
- Create a database with the specified name
- Create a database user with the specified username and password
- Use the BUILT_IN user type (standard PostgreSQL authentication)

## Variables and Outputs

### Important Variables

- **machine_tier**: Defines the machine resources (CPU and memory)
- **availability_type**: Controls high availability (ZONAL vs REGIONAL)
- **enable_private_ip** and **network_id**: Control network access mode
- **authorized_networks**: List of CIDRs allowed to connect if using public IP
- **database_flags**: PostgreSQL configuration parameters

### Key Outputs

- **instance_connection_name**: Used for connecting with Cloud SQL Proxy
- **instance_ip_address**: The IP address for direct connections
- **connection_string**: PostgreSQL connection string for client applications
- **console_url**: Direct link to the instance in Cloud Console

## Common Issues and Solutions

1. **API activation timeouts**: Increase the timeouts in the google_project_service resource
2. **Permission denied**: Ensure your GCP account has Cloud SQL Admin role
3. **Network connectivity issues**: 
   - For public IP: check that your IP is in the authorized networks
   - For private IP: ensure VPC peering is properly configured
4. **Creation takes a long time**: Cloud SQL instance creation can take up to 10-15 minutes

## Advanced Customizations

For more complex deployments, consider:

1. Creating read replicas for read scaling:
```terraform
resource "google_sql_database_instance" "replica" {
  name                 = "${var.instance_name}-replica"
  master_instance_name = google_sql_database_instance.postgres.name
  region               = var.region
  database_version     = "POSTGRES_14"

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = var.machine_tier
    availability_type = var.availability_type
    
    # IP configuration similar to master
    # ...
  }

  deletion_protection = false
}
```

2. Setting up maintenance windows:
```terraform
# Add to settings block
maintenance_window {
  day          = 7  # Sunday
  hour         = 2  # 2 AM
  update_track = "stable"
}
```

3. Implementing database insights for monitoring:
```terraform
# Add to settings block
insights_config {
  query_insights_enabled  = true
  query_string_length     = 1024
  record_application_tags = true
  record_client_address   = true
}
``` 