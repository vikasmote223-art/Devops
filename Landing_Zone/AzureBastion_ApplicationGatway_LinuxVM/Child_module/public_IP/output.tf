output "public_ip_ids" {
  value = {
    for k, v in azurerm_public_ip.public_ip : k => v.id
  }
}
