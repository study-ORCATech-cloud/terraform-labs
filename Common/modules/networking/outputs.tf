output "network_id" {
  description = "ID of the created network"
  value = coalescelist(
    aws_vpc.this[*].id,
    azurerm_virtual_network.this[*].id,
    google_compute_network.this[*].id,
    [""]
  )[0]
}

output "subnet_id" {
  description = "ID of the created subnet"
  value = coalescelist(
    aws_subnet.this[*].id,
    azurerm_subnet.this[*].id,
    google_compute_subnetwork.this[*].id,
    [""]
  )[0]
}

output "network_name" {
  description = "Name of the created network"
  value = coalescelist(
    aws_vpc.this[*].tags.Name,
    azurerm_virtual_network.this[*].name,
    google_compute_network.this[*].name,
    [""]
  )[0]
}

output "subnet_cidr" {
  description = "CIDR block of the created subnet"
  value = coalescelist(
    aws_subnet.this[*].cidr_block,
    azurerm_subnet.this[*].address_prefixes[0],
    google_compute_subnetwork.this[*].ip_cidr_range,
    [""]
  )[0]
}
