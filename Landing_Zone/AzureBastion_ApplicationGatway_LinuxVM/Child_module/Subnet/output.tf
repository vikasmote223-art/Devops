output "subnet_id" {
  value = {
    for k, v in azurerm_subnet.subnet : k => v.id
  }
}
