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
variable "NIC" {}
variable "VM" {}

resource "azurerm_resource_group" "RG" {
  for_each = var.RG
  name     = each.value.name
  location = each.value.location

}

resource "azurerm_virtual_network" "Vnet" {
  for_each            = var.Vnet
  name                = each.value.name
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  address_space       = each.value.address_space
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name

}

resource "azurerm_subnet" "Subnet" {

  for_each             = var.Subnet
  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.RG[each.value.resource_group_name].name
  virtual_network_name = azurerm_virtual_network.Vnet[each.value.virtual_network_name].name
  address_prefixes     = each.value.address_prefixes

}

resource "azurerm_network_interface" "NIC" {
  for_each            = var.NIC
  name                = each.value.name
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = azurerm_subnet.Subnet[each.value.subnet_name].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "VM" {
  for_each              = var.VM
  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.RG[each.value.resource_group_name].name
  location              = azurerm_resource_group.RG[each.value.resource_group_name].location
  size                  = "Standard_D2s_v3"
  admin_username        = "Vikas"
  admin_password        = "Vikas@12345"
  network_interface_ids = [azurerm_network_interface.NIC[each.value.nic_name].id]

  disable_password_authentication = false
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

resource "azurerm_public_ip" "LBPublicIP" {
  name                = "Vikas_PublicIP"
  location            = azurerm_resource_group.RG["RG1"].location
  resource_group_name = azurerm_resource_group.RG["RG1"].name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "loadbalancer" {

  name                = "Vikas_LB"
  location            = azurerm_resource_group.RG["RG1"].location
  resource_group_name = azurerm_resource_group.RG["RG1"].name

  sku = "Standard"
  frontend_ip_configuration {

    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.LBPublicIP.id
  }

}

resource "azurerm_lb_backend_address_pool" "backendpool" {
  name            = "Vikas_BackendPool"
  loadbalancer_id = azurerm_lb.loadbalancer.id
}

resource "azurerm_network_interface_backend_address_pool_association" "NIC_BackendPool_Association" {
  for_each                = var.NIC
  network_interface_id    = azurerm_network_interface.NIC[each.key].id
  ip_configuration_name   = "configuration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool.id
}

resource "azurerm_lb_probe" "lbprobe" {
  name            = "Vikas_LBProbe"
  loadbalancer_id = azurerm_lb.loadbalancer.id
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "lbrule" {
  name                           = "Vikas_LBRule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.lbprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backendpool.id]
}

resource "azurerm_network_security_group" "NSG" {

  for_each            = var.NIC
  name                = "${each.value.name}-NSG"
  location            = azurerm_resource_group.RG[each.value.resource_group_name].location
  resource_group_name = azurerm_resource_group.RG[each.value.resource_group_name].name

  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_network_interface_security_group_association" "NIC_NSG_Association" {
  for_each                  = var.NIC
  network_interface_id      = azurerm_network_interface.NIC[each.key].id
  network_security_group_id = azurerm_network_security_group.NSG[each.key].id
}


resource "azurerm_public_ip" "BastionPublicIP" {
  name                = "Vikas_BastionPublicIP"
  location            = azurerm_resource_group.RG["RG1"].location
  resource_group_name = azurerm_resource_group.RG["RG1"].name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_bastion_host" "BastionHost" {
  name                = "Vikas_BastionHost"
  location            = azurerm_resource_group.RG["RG1"].location
  resource_group_name = azurerm_resource_group.RG["RG1"].name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.Subnet["Subnet3"].id
    public_ip_address_id = azurerm_public_ip.BastionPublicIP.id
  }
}

resource "azurerm_public_ip" "NATPublicIP" {
  name                = "Vikas_NATPublicIP"
  location            = azurerm_resource_group.RG["RG1"].location
  resource_group_name = azurerm_resource_group.RG["RG1"].name
  allocation_method   = "Static"
  sku                 = "Standard"

}

resource "azurerm_nat_gateway" "NATGateway" {
  name                = "Vikas_NATGateway"
  location            = azurerm_resource_group.RG["RG1"].location
  resource_group_name = azurerm_resource_group.RG["RG1"].name
  sku_name            = "Standard"
}
resource "azurerm_nat_gateway_public_ip_association" "NATGateway_PublicIP_Association" {
  nat_gateway_id       = azurerm_nat_gateway.NATGateway.id
  public_ip_address_id = azurerm_public_ip.NATPublicIP.id
}

resource "azurerm_subnet_nat_gateway_association" "Subnet1_NATGateway_Association" {
  subnet_id      = azurerm_subnet.Subnet["Subnet1"].id
  nat_gateway_id = azurerm_nat_gateway.NATGateway.id
}
resource "azurerm_subnet_nat_gateway_association" "Subnet2_NATGateway_Association" {
  subnet_id      = azurerm_subnet.Subnet["Subnet2"].id
  nat_gateway_id = azurerm_nat_gateway.NATGateway.id
}

