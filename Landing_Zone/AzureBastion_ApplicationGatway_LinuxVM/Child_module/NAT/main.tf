resource "azurerm_nat_gateway" "nat" {
  for_each            = var.nat_gateway
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
}

resource "azurerm_nat_gateway_public_ip_association" "pip_assoc" {
  for_each = var.nat_gateway

  nat_gateway_id       = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = each.value.public_ip_address_id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_assoc" {
  for_each = var.nat_gateway

  subnet_id      = each.value.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat[each.key].id
}
