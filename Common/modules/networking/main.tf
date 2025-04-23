# Common networking module for multi-cloud environments

locals {
  create_aws   = var.provider_type == "aws" ? 1 : 0
  create_azure = var.provider_type == "azure" ? 1 : 0
  create_gcp   = var.provider_type == "gcp" ? 1 : 0
}

# AWS Resources
resource "aws_vpc" "this" {
  count      = local.create_aws
  cidr_block = var.cidr_block

  tags = merge(
    var.tags,
    {
      Name = var.network_name
    }
  )
}

resource "aws_subnet" "this" {
  count      = local.create_aws
  vpc_id     = aws_vpc.this[0].id
  cidr_block = var.subnet_cidr

  tags = merge(
    var.tags,
    {
      Name = "${var.network_name}-subnet"
    }
  )
}

# Azure Resources
resource "azurerm_virtual_network" "this" {
  count               = local.create_azure
  name                = var.network_name
  address_space       = [var.cidr_block]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "this" {
  count                = local.create_azure
  name                 = "${var.network_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = [var.subnet_cidr]
}

# GCP Resources
resource "google_compute_network" "this" {
  count                   = local.create_gcp
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  count         = local.create_gcp
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.location
  network       = google_compute_network.this[0].id
} 
