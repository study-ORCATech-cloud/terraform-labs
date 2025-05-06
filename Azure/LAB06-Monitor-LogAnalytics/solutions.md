# LAB06: Monitor Azure Resources with Azure Monitor and Log Analytics Solution

This document provides solutions for the Azure Monitor and Log Analytics lab. It's intended for instructor use and to help students who are stuck with specific tasks.

## Main Terraform Configuration Solution

Below is the complete solution for the `main.tf` file with all TODOs implemented:

```terraform
provider "azurerm" {
  features {}
}

# Create a resource group for monitoring resources
resource "azurerm_resource_group" "monitoring_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.workspace_name
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}

# Network resources for test VM (if enabled)
resource "azurerm_virtual_network" "test_vnet" {
  count               = var.create_test_vm ? 1 : 0
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "test_subnet" {
  count                = var.create_test_vm ? 1 : 0
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.monitoring_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet[0].name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "test_nic" {
  count               = var.create_test_vm ? 1 : 0
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet[0].id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a test Virtual Machine for monitoring purposes (optional)
resource "azurerm_linux_virtual_machine" "test_vm" {
  count               = var.create_test_vm ? 1 : 0
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  location            = azurerm_resource_group.monitoring_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.test_nic[0].id,
  ]
  tags = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

# Configure diagnostic settings for the VM
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  count                      = var.create_test_vm ? 1 : 0
  name                       = "${var.vm_name}-diagnostics"
  target_resource_id         = azurerm_linux_virtual_machine.test_vm[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }
}

# Create an Action Group for sending alert notifications
resource "azurerm_monitor_action_group" "email_action_group" {
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  short_name          = "mlabalerts"

  email_receiver {
    name                    = "admin-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

# Create a Metric Alert for the VM
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  count               = var.create_test_vm ? 1 : 0
  name                = var.alert_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  scopes              = [azurerm_linux_virtual_machine.test_vm[0].id]
  description         = "Alert when CPU usage exceeds ${var.cpu_threshold}%"
  severity            = var.alert_severity
  window_size         = "PT5M"
  frequency           = "PT1M"
  auto_mitigate       = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_action_group.id
  }
}

# Create a custom query (saved search) in Log Analytics
resource "azurerm_log_analytics_saved_search" "high_cpu_query" {
  name                       = var.query_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  category                   = "VM Insights"
  display_name               = "High CPU Usage Events"
  query                      = <<-QUERY
    // Query for high CPU events from VMs
    Perf
    | where ObjectName == "Processor" and CounterName == "% Processor Time"
    | where CounterValue > ${var.cpu_threshold}
    | summarize AggregatedValue = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
    | sort by TimeGenerated desc
  QUERY
}
```

## Step-by-Step Explanation

### 1. Configure the Azure Provider

```terraform
provider "azurerm" {
  features {}
}
```

This configures the Azure Resource Manager provider. The empty `features {}` block is required by the provider.

### 2. Create a Resource Group

```terraform
resource "azurerm_resource_group" "monitoring_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}
```

This creates a resource group, which is a logical container for all the resources in this lab.

### 3. Create a Log Analytics Workspace

```terraform
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.workspace_name
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_days
  tags                = var.tags
}
```

The Log Analytics workspace is the central repository where all logs and metrics will be stored and analyzed. The "PerGB2018" SKU is the standard pricing tier that charges based on data ingestion.

### 4. Create Network Resources for Test VM (if enabled)

```terraform
# Network resources for test VM (if enabled)
resource "azurerm_virtual_network" "test_vnet" {
  count               = var.create_test_vm ? 1 : 0
  name                = "${var.vm_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "test_subnet" {
  count                = var.create_test_vm ? 1 : 0
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.monitoring_rg.name
  virtual_network_name = azurerm_virtual_network.test_vnet[0].name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "test_nic" {
  count               = var.create_test_vm ? 1 : 0
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.monitoring_rg.location
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet[0].id
    private_ip_address_allocation = "Dynamic"
  }
}
```

These resources create the networking infrastructure required for the test VM. The `count` parameter ensures these resources are only created if `create_test_vm` is set to true.

### 5. Create a Test Virtual Machine

```terraform
resource "azurerm_linux_virtual_machine" "test_vm" {
  count               = var.create_test_vm ? 1 : 0
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  location            = azurerm_resource_group.monitoring_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.test_nic[0].id,
  ]
  tags = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

This creates a basic Ubuntu virtual machine that will be used to generate metrics and logs for monitoring. It is only created if `create_test_vm` is set to true.

### 6. Configure Diagnostic Settings for the VM

```terraform
resource "azurerm_monitor_diagnostic_setting" "vm_diagnostics" {
  count                      = var.create_test_vm ? 1 : 0
  name                       = "${var.vm_name}-diagnostics"
  target_resource_id         = azurerm_linux_virtual_machine.test_vm[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
      days    = var.retention_days
    }
  }
}
```

This configures diagnostic settings to send all VM metrics to the Log Analytics workspace. This is essential for monitoring the VM's performance.

### 7. Create an Action Group for Notifications

```terraform
resource "azurerm_monitor_action_group" "email_action_group" {
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  short_name          = "mlabalerts"

  email_receiver {
    name                    = "admin-email"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}
```

This creates an action group that defines what happens when an alert is triggered. In this case, it will send an email to the specified address.

### 8. Create a Metric Alert for the VM

```terraform
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  count               = var.create_test_vm ? 1 : 0
  name                = var.alert_name
  resource_group_name = azurerm_resource_group.monitoring_rg.name
  scopes              = [azurerm_linux_virtual_machine.test_vm[0].id]
  description         = "Alert when CPU usage exceeds ${var.cpu_threshold}%"
  severity            = var.alert_severity
  window_size         = "PT5M"
  frequency           = "PT1M"
  auto_mitigate       = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_action_group.id
  }
}
```

This creates an alert rule that monitors CPU usage on the VM. If the average CPU usage exceeds the specified threshold over a 5-minute window, it will trigger the action group to send an email notification.

### 9. Create a Custom Query in Log Analytics

```terraform
resource "azurerm_log_analytics_saved_search" "high_cpu_query" {
  name                       = var.query_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  category                   = "VM Insights"
  display_name               = "High CPU Usage Events"
  query                      = <<-QUERY
    // Query for high CPU events from VMs
    Perf
    | where ObjectName == "Processor" and CounterName == "% Processor Time"
    | where CounterValue > ${var.cpu_threshold}
    | summarize AggregatedValue = avg(CounterValue) by Computer, bin(TimeGenerated, 5m)
    | sort by TimeGenerated desc
  QUERY
}
```

This creates a saved search in Log Analytics that uses Kusto Query Language (KQL) to find instances where CPU usage exceeded the threshold. This query can be run directly in the Log Analytics workspace for troubleshooting and analysis.

## Common Issues and Solutions

1. **Log Analytics workspace not receiving data**: Ensure diagnostic settings are properly configured and the VM is generating metrics.

2. **Alerts not triggering**: Check that the alert criteria (threshold, window size) are appropriate and that the VM is generating enough load to trigger the alert.

3. **Custom query returns no results**: It may take time for performance data to be collected and indexed in the Log Analytics workspace. Try running the stress test for at least 10 minutes.

4. **Email notifications not received**: Verify the email address in the action group is correct and check spam folders.

## Testing the Monitoring Setup

1. **Generate CPU load**: Use the Azure CLI or Azure Portal to run a stress test on the VM:
   ```bash
   az vm run-command invoke --resource-group monitoring-lab-rg --name monitoring-test-vm --command-id RunShellScript --scripts "apt-get update && apt-get install -y stress && stress --cpu 8 --timeout 600"
   ```

2. **View metrics in Azure Portal**: Navigate to the VM in Azure Portal, select "Metrics" from the left menu, and add the "Percentage CPU" metric.

3. **Check for alerts**: Navigate to Azure Monitor > Alerts to see if any alerts were triggered during the stress test.

4. **Run the custom query**: In the Log Analytics workspace, go to "Logs" and run the saved query to see high CPU events.

## Advanced Scenarios (for additional practice)

1. **Create a dashboard**: Use the `azurerm_dashboard` resource to create a custom dashboard with CPU usage charts.

2. **Set up VM Insights**: Enable VM Insights for deeper performance monitoring and dependency mapping.

3. **Create multiple alert rules**: Set up alerts for other metrics like memory usage, disk I/O, or network traffic.

4. **Configure more action types**: Add SMS, webhook, or Azure Function actions to the action group.

5. **Implement log-based alerts**: Create alerts based on specific patterns in log data using log search queries. 