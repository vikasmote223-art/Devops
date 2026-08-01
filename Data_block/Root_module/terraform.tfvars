resource_groups_Data = {
  rg1 = {
    name     = "Vikas_RG"
    location = "East US"
  }

}
virtual_networks_Data = {
  vnet1 = {
    name                = "Vikas_Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = "Vikas_RG"
  }
}

subnets_Data = {
  subnet1 = {
    name                 = "Vikas_Subnet"
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

network_interfaces_Data = {
  nic1 = {
    name                = "Vikas_NIC"
    location            = "East US"
    resource_group_name = "Vikas_RG"
    subnet_name         = "Vikas_Subnet"
    vnet_name           = "Vikas_Vnet"
  }
}
