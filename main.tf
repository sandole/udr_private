# Provider info
terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source    = "hashicorp/azurerm"
      version   = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Rt Rg
resource "azurerm_resource_group" "vnetrg" {
  name = "${var.prefix}vnetrg"
  location = var.location
}

# Route Tables
resource "azurerm_route_table" "to_fw_route_table" {
  name                = "EsToFirewallRt"
  location            = azurerm_resource_group.vnetrg.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  tags                = var.tags

  route {
    name                   = "RouteAllToFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.133.4"
  }

  route {
    name                   = "RouteHub172TrafficToFirewall"
    address_prefix         = "172.16.128.0/18"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.133.4"
  }

  route {
    name                   = "RouteHub194TrafficToFirewall"
    address_prefix         = "100.97.194.0/25"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.133.4"
  }

  route {
    name                   = "RouteHub195TrafficToFirewall"
    address_prefix         = "100.97.195.0/25"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.133.4"
  }
}

#RouteAllToCentralFirewallEgressLbVip
resource "azurerm_route_table" "all_to_load_balancer" {
  name                = "AllToCentralFirewallRt"
  location            = azurerm_resource_group.vnetrg.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  tags                = var.tags

  route {
    name = "RouteAllToFirewall"
    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = "172.16.133.4"
  }
}