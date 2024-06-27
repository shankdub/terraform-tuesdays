terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "2.99.0"
        }
    }
}

provider "azurerm" {
    features {}
    alias = "malibu"
}

resource "azurerm_resource_group" "tacos" {
    name = "tacotest"
    location = "East US"
    provider = azurerm.malibu
}