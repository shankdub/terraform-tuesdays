provider "azurerm" {
  features {}
}

variable "region" {
  type        = string
  default     = "eastus"
  description = "Azure region to deploy resources."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group in which to create resources."
}

variable "vnet_address_space" {
  type = string
    description = "Address space for the virtual network."
    default = "10.0.0.0/16"
}

variable "app_config_store_id" {
  type = string
  description = "ID of the App Configuration store."
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_app_configuration_key" "cidr_list" {
  configuration_store_id = var.app_config_store_id
  key = "cidr_lists"
  label = var.region
}

resource "azurerm_virtual_network" "main" {
  name                = "taconet"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = [var.vnet_address_space]

  lifecycle {
    precondition {
      condition     = var.region == data.azurerm_resource_group.main.location
      error_message = "The resource group ${var.resource_group_name} is not in the region ${var.region}"
    }

    precondition {
      condition = contains(split(",",data.azurerm_app_configuration_key.cidr_list.value), var.vnet_address_space)
    }
  }
}
