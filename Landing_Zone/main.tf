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

variable "RG" {}
variable "Vnet" {}
variable "Subnet" {}
variable "WindowsVM" {}
variable "LinuxVM" {}
variable "nic" {}

resource "azurerm_resource_group" "RG" {
  for_each = var.RG

  name     = each.value.name
  location = each.value.location

}

resource "azurerm_virtual_network" "Vnet" {
  for_each            = var.Vnet
  name                = each.value.name
  address_space       = each.value.address_space
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name
}

resource "azurerm_subnet" "Subnet" {
  for_each             = var.Subnet
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.RG[each.value.resource_group_name].name
  virtual_network_name = azurerm_virtual_network.Vnet[each.value.virtual_network_name].name
  address_prefixes     = each.value.address_prefixes

}

resource "azurerm_network_interface" "nic" {
  for_each            = var.nic
  name                = each.value.name
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet[each.value.subnet_id].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "windowsVM" {
  for_each            = var.WindowsVM
  name                = each.value.name
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  size                = "Standard_B1s"

  admin_username = "Vikas"
  admin_password = "Vikas@123"

  network_interface_ids = [azurerm_network_interface.nic[each.value.network_interface_id].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "linuxVM" {
  for_each            = var.LinuxVM
  name                = each.value.name
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  size                = "Standard_B1s"

  admin_username = "Vikas"
  admin_password = "Vikas@123"

  network_interface_ids = [azurerm_network_interface.nic[each.value.network_interface_id].id]

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
