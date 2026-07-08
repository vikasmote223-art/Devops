output "network_interface_ids" {
  value = {
    for k, v in azurerm_network_interface.NIC : k => v.id
  }
}
