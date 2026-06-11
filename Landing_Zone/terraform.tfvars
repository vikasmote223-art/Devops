RG = {
  RG1 = {

    name     = "Vikas_RG"
    location = "australiaeast"
  }
}
Vnet = {
  Vnet1 = {
    name                = "Vikas_Vnet"
    address_space       = ["10.0.0.0/24"]
    resource_group_name = "RG1"
  }
}

Subnet = {

  LinuxSubnet = {
    name                 = "LinuxSubnet"
    address_prefixes     = ["10.0.0.0/25"]
    virtual_network_name = "Vnet1"
    resource_group_name  = "RG1"
  }
  WindowsSubnet = {
    name                 = "WindowsSubnet"
    address_prefixes     = ["10.0.0.128/25"]
    virtual_network_name = "Vnet1"
    resource_group_name  = "RG1"
  }
}

nic = {
  nic1 = {
    name                = "linux-nic"
    resource_group_name = "RG1"
    subnet_id           = "LinuxSubnet"
  }
  nic2 = {
    name                = "windows-nic"
    resource_group_name = "RG1"
    subnet_id           = "WindowsSubnet"
  }
}

WindowsVM = {
  VM1 = {
    name                 = "WindowsVM"
    resource_group_name  = "RG1"
    network_interface_id = "nic2"
  }
}
LinuxVM = {
  VM1 = {
    name                 = "LinuxVM"
    resource_group_name  = "RG1"
    network_interface_id = "nic1"
  }
}
