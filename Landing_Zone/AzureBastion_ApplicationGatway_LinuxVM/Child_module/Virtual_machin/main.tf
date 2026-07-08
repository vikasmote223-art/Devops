
resource "azurerm_linux_virtual_machine" "VM" {
  for_each                        = var.virtual_machines
  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  network_interface_ids           = [each.value.network_interface_ids]
  size                            = each.value.size
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
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
