# LAB06: Cloud Monitoring and Logging Solutions

This document provides solutions for the Cloud Monitoring and Logging lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable the Cloud Monitoring API
resource "google_project_service" "monitoring_api" {
  service            = "monitoring.googleapis.com"
  disable_on_destroy = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Enable the Cloud Logging API
resource "google_project_service" "logging_api" {
  service            = "logging.googleapis.com"
  disable_on_destroy = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

# Create a CPU utilization alert policy
resource "google_monitoring_alert_policy" "cpu_utilization" {
  display_name = "High CPU Utilization Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "VM Instance - High CPU utilization condition"
    
    condition_threshold {
      filter     = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration   = var.alert_duration
      comparison = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
      
      trigger {
        count = 1
      }
    }
  }
  
  documentation {
    content   = var.alert_documentation
    mime_type = "text/markdown"
  }
  
  notification_channels = var.notification_channels
  
  depends_on = [google_project_service.monitoring_api]
}

# Create a Network egress alert policy
resource "google_monitoring_alert_policy" "network_egress" {
  display_name = "High Network Egress Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "VM Instance - High network egress condition"
    
    condition_threshold {
      filter     = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/network/sent_bytes_count\""
      duration   = var.alert_duration
      comparison = "COMPARISON_GT"
      threshold_value = var.network_threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      
      trigger {
        count = 1
      }
    }
  }
  
  documentation {
    content   = var.alert_documentation
    mime_type = "text/markdown"
  }
  
  notification_channels = var.notification_channels
  
  depends_on = [google_project_service.monitoring_api]
}

# Create a basic dashboard
resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "${var.dashboard_name}",
  "gridLayout": {
    "widgets": [
      {
        "title": "CPU Utilization",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN"
                  }
                }
              },
              "plotType": "LINE"
            }
          ],
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Network Egress",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/network/sent_bytes_count\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE"
                  }
                }
              },
              "plotType": "LINE"
            }
          ],
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}
EOF

  depends_on = [google_project_service.monitoring_api]
}

# Create a logs bucket for storing logs (if enabled)
resource "google_storage_bucket" "logs_bucket" {
  count = var.create_logs_bucket ? 1 : 0
  
  name          = var.logs_bucket_name != "" ? var.logs_bucket_name : "logs-${var.project_id}"
  location      = var.region
  storage_class = var.logs_storage_class
  
  uniform_bucket_level_access = true
  
  lifecycle_rule {
    condition {
      age = var.logs_retention_days
    }
    action {
      type = "Delete"
    }
  }
  
  labels = var.labels
}

# Create a BigQuery dataset for logs (if enabled)
resource "google_bigquery_dataset" "logs_dataset" {
  count = var.create_logs_bigquery ? 1 : 0
  
  dataset_id                  = var.logs_dataset_id
  location                    = var.region
  delete_contents_on_destroy  = true
  
  labels = var.labels
}

# Create a log sink for VM instance logs
resource "google_logging_project_sink" "vm_logs" {
  name = "vm-instance-logs-sink"
  
  # Filter to only capture compute instance logs
  filter = "resource.type = \"gce_instance\""
  
  # Destination based on chosen storage
  destination = var.create_logs_bucket ? "storage.googleapis.com/${google_storage_bucket.logs_bucket[0].name}" : (
                var.create_logs_bigquery ? "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs_dataset[0].dataset_id}" : 
                "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/_Default"
  )
  
  # Required for the permission below to work correctly
  unique_writer_identity = true
  
  depends_on = [
    google_project_service.logging_api,
    google_storage_bucket.logs_bucket,
    google_bigquery_dataset.logs_dataset
  ]
}

# Set permissions for the log sink to write to the destination
resource "google_project_iam_binding" "log_writer" {
  count = var.create_logs_bucket || var.create_logs_bigquery ? 1 : 0
  
  project = var.project_id
  role    = var.create_logs_bucket ? "roles/storage.objectCreator" : "roles/bigquery.dataEditor"
  
  members = [
    google_logging_project_sink.vm_logs.writer_identity,
  ]
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

This configures the Google Cloud provider with your project ID and region, which are passed from variables to allow flexibility across different environments.

### 2. Enable Required APIs

```terraform
resource "google_project_service" "monitoring_api" {
  service            = "monitoring.googleapis.com"
  disable_on_destroy = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}

resource "google_project_service" "logging_api" {
  service            = "logging.googleapis.com"
  disable_on_destroy = true
  disable_dependent_services = true
  timeouts {
    create = "30m"
    update = "40m"
  }
}
```

This enables the Cloud Monitoring and Cloud Logging APIs in your GCP project. The resource:

- Specifies which API service to enable
- Sets `disable_on_destroy` to true to disable the API when you run `terraform destroy`
- Sets custom timeouts to allow for API activation, which can take time
- Disables dependent services when destroying to prevent orphaned resources

### 3. Create a CPU Utilization Alert Policy

```terraform
resource "google_monitoring_alert_policy" "cpu_utilization" {
  display_name = "High CPU Utilization Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "VM Instance - High CPU utilization condition"
    
    condition_threshold {
      filter     = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      duration   = var.alert_duration
      comparison = "COMPARISON_GT"
      threshold_value = var.cpu_threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
      
      trigger {
        count = 1
      }
    }
  }
  
  documentation {
    content   = var.alert_documentation
    mime_type = "text/markdown"
  }
  
  notification_channels = var.notification_channels
  
  depends_on = [google_project_service.monitoring_api]
}
```

This creates an alert policy that triggers when CPU utilization exceeds a threshold. The policy:

- Uses a filter to monitor the CPU utilization metric for Compute Engine instances
- Sets a threshold (e.g., 0.8 = 80%) from variables
- Defines a duration for which the threshold must be exceeded before alerting
- Configures aggregation to use the mean value over 60-second periods
- Includes documentation that will be displayed with the alert
- Associates notification channels (if provided) to send alerts
- Depends on the Monitoring API being enabled

### 4. Create a Network Egress Alert Policy

```terraform
resource "google_monitoring_alert_policy" "network_egress" {
  display_name = "High Network Egress Alert"
  combiner     = "OR"
  
  conditions {
    display_name = "VM Instance - High network egress condition"
    
    condition_threshold {
      filter     = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/network/sent_bytes_count\""
      duration   = var.alert_duration
      comparison = "COMPARISON_GT"
      threshold_value = var.network_threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      
      trigger {
        count = 1
      }
    }
  }
  
  documentation {
    content   = var.alert_documentation
    mime_type = "text/markdown"
  }
  
  notification_channels = var.notification_channels
  
  depends_on = [google_project_service.monitoring_api]
}
```

This creates a similar alert for network egress traffic. The key differences are:

- Uses the `sent_bytes_count` metric instead of CPU utilization
- Uses `ALIGN_RATE` alignment to calculate the rate of bytes sent per second
- Has a different threshold value appropriate for network traffic

### 5. Create a Monitoring Dashboard

```terraform
resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "${var.dashboard_name}",
  "gridLayout": {
    "widgets": [
      {
        "title": "CPU Utilization",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_MEAN"
                  }
                }
              },
              "plotType": "LINE"
            }
          ],
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      },
      {
        "title": "Network Egress",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/network/sent_bytes_count\"",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE"
                  }
                }
              },
              "plotType": "LINE"
            }
          ],
          "yAxis": {
            "label": "y1Axis",
            "scale": "LINEAR"
          }
        }
      }
    ]
  }
}
EOF

  depends_on = [google_project_service.monitoring_api]
}
```

This creates a custom monitoring dashboard with two charts:

- The first chart displays CPU utilization across instances
- The second chart displays network egress traffic
- Both charts use the same metrics and aggregations as the alert policies
- The dashboard is defined using JSON configuration, which allows for complex layouts
- The `depends_on` ensures the Monitoring API is enabled before creating the dashboard

### 6. Create Storage for Logs (Conditional)

```terraform
resource "google_storage_bucket" "logs_bucket" {
  count = var.create_logs_bucket ? 1 : 0
  
  name          = var.logs_bucket_name != "" ? var.logs_bucket_name : "logs-${var.project_id}"
  location      = var.region
  storage_class = var.logs_storage_class
  
  uniform_bucket_level_access = true
  
  lifecycle_rule {
    condition {
      age = var.logs_retention_days
    }
    action {
      type = "Delete"
    }
  }
  
  labels = var.labels
}
```

This conditionally creates a Cloud Storage bucket for logs if `create_logs_bucket` is true. The bucket:

- Uses a name provided by the user or generates one based on the project ID
- Sets a location and storage class for the bucket
- Enables uniform bucket-level access for simplified permissions
- Adds a lifecycle rule to automatically delete old logs after a specified number of days
- Adds labels for resource management

Similarly, for BigQuery:

```terraform
resource "google_bigquery_dataset" "logs_dataset" {
  count = var.create_logs_bigquery ? 1 : 0
  
  dataset_id                  = var.logs_dataset_id
  location                    = var.region
  delete_contents_on_destroy  = true
  
  labels = var.labels
}
```

This conditionally creates a BigQuery dataset for logs storage and analysis if enabled.

### 7. Create a Log Sink

```terraform
resource "google_logging_project_sink" "vm_logs" {
  name = "vm-instance-logs-sink"
  
  # Filter to only capture compute instance logs
  filter = "resource.type = \"gce_instance\""
  
  # Destination based on chosen storage
  destination = var.create_logs_bucket ? "storage.googleapis.com/${google_storage_bucket.logs_bucket[0].name}" : (
                var.create_logs_bigquery ? "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs_dataset[0].dataset_id}" : 
                "logging.googleapis.com/projects/${var.project_id}/locations/global/buckets/_Default"
  )
  
  # Required for the permission below to work correctly
  unique_writer_identity = true
  
  depends_on = [
    google_project_service.logging_api,
    google_storage_bucket.logs_bucket,
    google_bigquery_dataset.logs_dataset
  ]
}
```

This creates a log sink that exports VM instance logs to the selected destination. The sink:

- Filters logs to only include those from Compute Engine instances
- Sets a destination based on whether Cloud Storage or BigQuery is enabled
- Falls back to the default log bucket if neither is enabled
- Sets a unique writer identity for granting permissions
- Depends on the Log API and appropriate storage resources

### 8. Set Permissions for the Log Sink

```terraform
resource "google_project_iam_binding" "log_writer" {
  count = var.create_logs_bucket || var.create_logs_bigquery ? 1 : 0
  
  project = var.project_id
  role    = var.create_logs_bucket ? "roles/storage.objectCreator" : "roles/bigquery.dataEditor"
  
  members = [
    google_logging_project_sink.vm_logs.writer_identity,
  ]
}
```

This grants the necessary permissions for the log sink to write to the destination. It:

- Only creates the binding if a destination is configured (Storage or BigQuery)
- Assigns the appropriate role based on the destination type
- Grants the permission to the sink's writer identity

## Variables and Outputs

### Important Variables

- **cpu_threshold** and **network_threshold**: Define alert triggers
- **alert_duration**: How long the threshold must be exceeded before alerting
- **notification_channels**: Where to send alerts
- **create_logs_bucket** and **create_logs_bigquery**: Control log storage options

### Key Outputs

- **dashboard_url**: Direct link to the monitoring dashboard
- **console_monitoring_url** and **console_logging_url**: Links to the monitoring and logging consoles
- **cpu_alert_policy_name** and **network_alert_policy_name**: Names of the created alert policies

## Common Issues and Solutions

1. **API activation timeouts**: Increase the timeouts in the google_project_service resources
2. **Permission denied**: Check your GCP account has appropriate permissions
3. **Metrics not appearing**: Ensure you have resources (VMs) generating metrics
4. **Log export failures**: Verify the log sink writer identity has proper permissions

## Advanced Customizations

For more complex deployments, consider:

1. Adding alert notification channels for email or Slack:
```terraform
resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notification Channel"
  type         = "email"
  
  labels = {
    email_address = "admin@example.com"
  }
}
```

2. Creating a more complex dashboard with multiple metrics:
```terraform
# Add to the dashboard JSON
"widgets": [
  # ... existing widgets
  {
    "title": "Disk Read Operations",
    "xyChart": {
      "dataSets": [
        {
          "timeSeriesQuery": {
            "timeSeriesFilter": {
              "filter": "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/disk/read_ops_count\"",
              "aggregation": {
                "alignmentPeriod": "60s",
                "perSeriesAligner": "ALIGN_RATE"
              }
            }
          },
          "plotType": "LINE"
        }
      ]
    }
  }
]
```

3. Implementing uptime checks for external HTTP endpoints:
```terraform
resource "google_monitoring_uptime_check_config" "http_check" {
  display_name = "HTTP Uptime Check"
  timeout      = "10s"
  period       = "60s"
  
  http_check {
    path = "/"
    port = "80"
  }
  
  monitored_resource {
    type = "uptime_url"
    labels = {
      host = "example.com"
    }
  }
}
``` 