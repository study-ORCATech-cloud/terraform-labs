# LAB01: Compute Engine VM Solutions

This document provides solutions for the Compute Engine VM lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  tags = var.network_tags
  
  labels = var.labels
  
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  
  network_interface {
    network = "default"
    
    access_config {
      // Ephemeral IP
    }
  }
  
  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }
  
  allow_stopping_for_update = var.allow_stopping_for_update
}

resource "google_compute_firewall" "http_firewall" {
  name    = "${var.instance_name}-allow-http"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.network_tags
}
```

## Step-by-Step Explanation

### 1. Configure the Google Cloud Provider

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}
```

This configures the Google Cloud provider with your project ID, region, and zone. These values are passed from variables, allowing flexibility across different environments.

### 2. Create a Compute Engine VM Instance

```terraform
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  tags = var.network_tags
  
  labels = var.labels
  
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  
  network_interface {
    network = "default"
    
    access_config {
      // Ephemeral IP
    }
  }
  
  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }
  
  allow_stopping_for_update = var.allow_stopping_for_update
}
```

This creates a Compute Engine VM instance with the following components:

- **name**: Sets the instance name from a variable
- **machine_type**: Defines the VM's CPU and memory configuration (e.g., e2-medium)
- **zone**: Specifies the GCP zone where the VM will be created
- **tags**: Network tags used for firewall rule targeting
- **labels**: Key-value pairs for organizing resources
- **boot_disk**: Configures the main OS disk with the specified image
- **network_interface**: Connects the VM to the default network and assigns an external IP
- **metadata**: Sets up SSH access by adding your public key to the VM
- **allow_stopping_for_update**: Allows Terraform to stop the VM for certain property updates

### 3. Create a Firewall Rule for HTTP Traffic

```terraform
resource "google_compute_firewall" "http_firewall" {
  name    = "${var.instance_name}-allow-http"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.network_tags
}
```

This creates a firewall rule allowing HTTP traffic to the VM:

- **name**: Creates a unique name based on the instance name
- **network**: Applies the rule to the default network
- **allow**: Permits TCP traffic on port 80 (HTTP)
- **source_ranges**: Allows traffic from any IP address (0.0.0.0/0)
- **target_tags**: Applies the rule only to instances with matching tags

## Variables and Outputs

### Important Variables

- **project_id**: Your Google Cloud project identifier
- **region** and **zone**: Where resources will be deployed
- **machine_type**: Determines VM performance and cost
- **image**: Defines the operating system
- **network_tags**: Used for firewall rule targeting

### Key Outputs

- **instance_external_ip**: For connecting to the VM
- **ssh_command**: Ready-to-use command for SSH access

## Common Issues and Solutions

1. **Authentication errors**: Ensure you've run `gcloud auth application-default login`
2. **Permission denied**: Check your project IAM permissions
3. **SSH key issues**: Verify the path to your public key file is correct
4. **Instance not accessible**: Confirm the firewall rule is properly configured

## Advanced Customizations

For more complex deployments, consider:

1. Adding a startup script:
```terraform
metadata_startup_script = "apt-get update && apt-get install -y nginx && systemctl start nginx"
```

2. Using a custom service account:
```terraform
service_account {
  email  = "custom-service-account@project-id.iam.gserviceaccount.com"
  scopes = ["cloud-platform"]
}
```

3. Adding additional network interfaces or persistent disks. 