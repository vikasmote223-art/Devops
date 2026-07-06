RG = {
  RG1 = {
    name     = "Vikas_RG"
    location = "central india"
  }
}
Vnet = {
  Vnet1 = {
    name                = "Vikas_Vnet"
    location            = "RG1"
    resource_group_name = "RG1"
    address_space       = ["10.0.0.0/24"]

  }
}

Subnet = {
  Subnet1 = {
    name                 = "Subnet1"
    resource_group_name  = "RG1"
    virtual_network_name = "Vnet1"
    address_prefixes     = ["10.0.0.0/26"]
  }

  Subnet2 = {
    name                 = "Subnet2"
    resource_group_name  = "RG1"
    virtual_network_name = "Vnet1"
    address_prefixes     = ["10.0.0.64/"]
  }
  Subnet3 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "RG1"
    virtual_network_name = "Vnet1"
    address_prefixes     = ["10.0.1.0/26"]
  }
}

NIC = {
  NIC1 = {
    name                = "Vikas_NIC1"
    location            = "RG1"
    resource_group_name = "RG1"
    subnet_name         = "Subnet1"

  }
  NIC2 = {
    name                = "Vikas_NIC2"
    location            = "RG1"
    resource_group_name = "RG1"
    subnet_name         = "Subnet2"
  }
}
VM = {
  VM1 = {
    name                = "VM1"
    resource_group_name = "RG1"
    location            = "RG1"
    nic_name            = "NIC1"
  }
  VM2 = {
    name                = "VM2"
    resource_group_name = "RG1"
    location            = "RG1"
    nic_name            = "NIC2"
  }
}
