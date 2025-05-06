# LAB05: LoadBalancer and Managed Instance Group Solutions

This document provides solutions for the Load Balancer and Managed Instance Group lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a health check for the backend service
resource "google_compute_health_check" "default" {
  name                = "${var.name_prefix}-health-check"
  check_interval_sec  = var.health_check_interval
  timeout_sec         = var.health_check_timeout
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  
  http_health_check {
    port         = 80
    request_path = "/"
  }
  
  description = "Health check for the managed instance group"
}

# Create an instance template
resource "google_compute_instance_template" "default" {
  name_prefix  = "${var.name_prefix}-template-"
  machine_type = var.machine_type
  
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }
  
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    cat <<'HTMLDOC' > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
        <title>Hello from Terraform</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background: linear-gradient(120deg, #2980b9, #8e44ad);
                color: white;
                text-align: center;
            }
            .container {
                max-width: 800px;
                padding: 20px;
                background-color: rgba(0, 0, 0, 0.3);
                border-radius: 10px;
            }
            h1 {
                font-size: 3em;
                margin-bottom: 10px;
            }
            p {
                font-size: 1.5em;
            }
            .instance {
                font-weight: bold;
                font-size: 1.2em;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Hello from Terraform!</h1>
            <p>This page is served from a Google Cloud Load Balancer and Managed Instance Group.</p>
            <div class="instance">
                Instance: $(hostname) | Internal IP: $(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
            </div>
        </div>
    </body>
    </html>
    HTMLDOC
    systemctl enable apache2
    systemctl restart apache2
  EOF
  
  tags = var.tags
  
  lifecycle {
    create_before_destroy = true
  }
  
  labels = var.labels
}

# Create a managed instance group
resource "google_compute_instance_group_manager" "default" {
  name               = "${var.name_prefix}-mig"
  zone               = var.zone
  base_instance_name = "${var.name_prefix}-vm"
  target_size        = var.enable_autoscaling ? null : var.instance_count
  
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  
  named_port {
    name = "http"
    port = 80
  }
  
  auto_healing_policies {
    health_check      = google_compute_health_check.default.id
    initial_delay_sec = 300
  }
}

# Create autoscaler (conditional)
resource "google_compute_autoscaler" "default" {
  count  = var.enable_autoscaling ? 1 : 0
  name   = "${var.name_prefix}-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.default.id
  
  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period
    
    cpu_utilization {
      target = 0.7
    }
  }
}

# Create a global address for the load balancer
resource "google_compute_global_address" "default" {
  name = "${var.name_prefix}-address"
}

# Create a backend service
resource "google_compute_backend_service" "default" {
  name                  = "${var.name_prefix}-backend-service"
  health_checks         = [google_compute_health_check.default.id]
  protocol              = "HTTP"
  timeout_sec           = var.backend_timeout
  connection_draining_timeout_sec = var.connection_draining_timeout
  
  backend {
    group = google_compute_instance_group_manager.default.instance_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# Create a URL map
resource "google_compute_url_map" "default" {
  name            = "${var.name_prefix}-url-map"
  default_service = google_compute_backend_service.default.id
}

# Create an HTTP proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.default.id
}

# Create a global forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.name_prefix}-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
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

### 2. Create a Health Check

```terraform
resource "google_compute_health_check" "default" {
  name                = "${var.name_prefix}-health-check"
  check_interval_sec  = var.health_check_interval
  timeout_sec         = var.health_check_timeout
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  
  http_health_check {
    port         = 80
    request_path = "/"
  }
  
  description = "Health check for the managed instance group"
}
```

This creates an HTTP health check that:

- Probes instances on port 80 at the "/" path
- Uses configurable intervals, timeouts, and thresholds from variables
- Is used by both the load balancer and the auto-healing policies

Health checks are critical for load balancing and auto-healing as they determine which instances receive traffic.

### 3. Create an Instance Template

```terraform
resource "google_compute_instance_template" "default" {
  name_prefix  = "${var.name_prefix}-template-"
  machine_type = var.machine_type
  
  disk {
    source_image = var.image
    auto_delete  = true
    boot         = true
  }
  
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
  
  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    # ... HTML and configuration ...
    systemctl enable apache2
    systemctl restart apache2
  EOF
  
  tags = var.tags
  
  lifecycle {
    create_before_destroy = true
  }
  
  labels = var.labels
}
```

This creates an instance template that:

- Defines the machine type and disk configuration
- Specifies a startup script that installs Apache and creates a custom HTML page
- Sets network tags for firewall rules
- Has a `create_before_destroy` lifecycle policy to prevent downtime during updates
- Includes labels for resource organization

The instance template is a blueprint for all VMs in the managed instance group.

### 4. Create a Managed Instance Group

```terraform
resource "google_compute_instance_group_manager" "default" {
  name               = "${var.name_prefix}-mig"
  zone               = var.zone
  base_instance_name = "${var.name_prefix}-vm"
  target_size        = var.enable_autoscaling ? null : var.instance_count
  
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  
  named_port {
    name = "http"
    port = 80
  }
  
  auto_healing_policies {
    health_check      = google_compute_health_check.default.id
    initial_delay_sec = 300
  }
}
```

This creates a managed instance group that:

- Uses the instance template as the VM blueprint
- Sets the target size (used only when autoscaling is disabled)
- Configures a named port, which is referenced by the backend service
- Sets up auto-healing to recreate unhealthy instances
- Uses an initial delay to allow instances time to start up

### 5. Configure Autoscaling (Optional)

```terraform
resource "google_compute_autoscaler" "default" {
  count  = var.enable_autoscaling ? 1 : 0
  name   = "${var.name_prefix}-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.default.id
  
  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = var.cooldown_period
    
    cpu_utilization {
      target = 0.7
    }
  }
}
```

This conditionally creates an autoscaler that:

- Only gets created if `enable_autoscaling` is true (using the count parameter)
- Scales the managed instance group based on CPU utilization
- Maintains instance count between min and max replicas
- Uses a cooldown period to prevent rapid scaling changes

Autoscaling allows the application to automatically adjust capacity based on load.

### 6. Create Load Balancer Components

The load balancer consists of multiple interconnected resources:

#### 6.1 Global IP Address

```terraform
resource "google_compute_global_address" "default" {
  name = "${var.name_prefix}-address"
}
```

This reserves a static global IP address for the load balancer.

#### 6.2 Backend Service

```terraform
resource "google_compute_backend_service" "default" {
  name                  = "${var.name_prefix}-backend-service"
  health_checks         = [google_compute_health_check.default.id]
  protocol              = "HTTP"
  timeout_sec           = var.backend_timeout
  connection_draining_timeout_sec = var.connection_draining_timeout
  
  backend {
    group = google_compute_instance_group_manager.default.instance_group
    balancing_mode = "UTILIZATION"
    capacity_scaler = 1.0
  }
}
```

The backend service:

- Defines how traffic is distributed to the instances
- References the health check to determine which instances are available
- Sets timeouts for connections and connection draining
- Configures the managed instance group as the backend

#### 6.3 URL Map

```terraform
resource "google_compute_url_map" "default" {
  name            = "${var.name_prefix}-url-map"
  default_service = google_compute_backend_service.default.id
}
```

The URL map routes requests to the appropriate backend service. In this case, all requests go to the same backend.

#### 6.4 HTTP Proxy

```terraform
resource "google_compute_target_http_proxy" "default" {
  name    = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.default.id
}
```

The HTTP proxy connects the forwarding rule to the URL map.

#### A Global Forwarding Rule

```terraform
resource "google_compute_global_forwarding_rule" "default" {
  name       = "${var.name_prefix}-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}
```

The forwarding rule directs traffic from the external IP address on port 80 to the HTTP proxy.

## Variables and Outputs

### Important Variables

- **name_prefix**: Creates consistent naming across resources
- **instance_count** and **enable_autoscaling**: Control the instance group size
- **machine_type** and **image**: Define the VM configuration
- **health_check_** parameters: Control health check behavior
- **tags**: Used by firewall rules to control access

### Key Outputs

- **load_balancer_ip**: The global IP address to access the application
- **curl_command**: Ready-to-use command to test the load balancer
- **gcloud_list_instances**: Command to view current instances in the MIG

## Common Issues and Solutions

1. **Health check failures**: Ensure port 80 is open and Apache is running
2. **Instances not scaling**: Check CPU utilization and autoscaling configuration
3. **Load balancer not accessible**: Verify firewall rules allow HTTP traffic
4. **Backend service errors**: Ensure the health check path exists on all instances

## Advanced Customizations

For more complex deployments, consider:

1. Adding an HTTPS listener with SSL certificate:
```terraform
resource "google_compute_ssl_certificate" "default" {
  name        = "${var.name_prefix}-certificate"
  private_key = file("path/to/private.key")
  certificate = file("path/to/certificate.crt")
}

resource "google_compute_target_https_proxy" "default" {
  name             = "${var.name_prefix}-https-proxy"
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}
```

2. Creating a regional managed instance group for higher availability:
```terraform
resource "google_compute_region_instance_group_manager" "default" {
  name               = "${var.name_prefix}-regional-mig"
  region             = var.region
  base_instance_name = "${var.name_prefix}-vm"
  
  // Other settings similar to zonal MIG
}
```

3. Implementing advanced routing with URL path-based rules:
```terraform
resource "google_compute_url_map" "advanced" {
  name            = "${var.name_prefix}-advanced-url-map"
  default_service = google_compute_backend_service.default.id
  
  host_rule {
    hosts        = ["example.com"]
    path_matcher = "path-matcher-1"
  }
  
  path_matcher {
    name            = "path-matcher-1"
    default_service = google_compute_backend_service.default.id
    
    path_rule {
      paths   = ["/api/*"]
      service = google_compute_backend_service.api.id
    }
  }
}