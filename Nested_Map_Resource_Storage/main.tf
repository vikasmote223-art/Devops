terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "RG_name" {}
variable "ST_name" {}

resource "azurerm_resource_group" "rg" {
  for_each = var.RG_name
  name     = each.value.name
  location = each.value.location
}

resource "azurerm_storage_account" "ST" {
  for_each                 = var.ST_name
  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.rg[each.value.resource_group_name].name
  location                 = azurerm_resource_group.rg[each.value.resource_group_name].location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}
