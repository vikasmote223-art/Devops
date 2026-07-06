resource_group_data = {

  rg = {
    name     = "Vikas_RG"
    location = "eastus"
  }
}

Vnet_data = {
  vnet1 = {
    name                = "Vikas_Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "Vikas_RG"
  }
}
subnet_data = {
  subnet1 = {
    name                 = "Vikas_Subnet1"
    resource_group_name  = "Vikas_RG"
    virtual_network_name = "Vikas_Vnet"
    address_prefixes     = ["10.0.1.0/24"]
  }

  subnet2 = {
    name                 = "Vikas_Subnet2"
    resource_group_name  = "Vikas_RG"
    virtual_network_name = "Vikas_Vnet"
    address_prefixes     = ["10.0.2.0/24"]
  }
}
