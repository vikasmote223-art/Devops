resource_group = {

  rg = {
    name     = "Vikas_RG"
    location = "central india"
  }
}

Vnet_DATA = {

  vnet = {
    name                = "Vikas_VNET"
    address_space       = ["10.0.0.0/24"]
    location            = "central india"
    resource_group_name = "Vikas_RG"
  }
}

Subnet_DATA = {

  subnet1 = {
    name                 = "VM1_Subnet"
    resource_group_name  = "Vikas_RG"
    virtual_network_name = "Vikas_VNET"
    address_prefixes     = ["10.0.0.0/26"]
    location             = "central india"
  }

  subnet2 = {
    name                 = "VM2_Subnet"
    resource_group_name  = "Vikas_RG"
    virtual_network_name = "Vikas_VNET"
    address_prefixes     = ["10.0.0.64/26"]
    location             = "central india"
  }
  subnet3 = {
    name                 = "application_gateway_subnet"
    resource_group_name  = "Vikas_RG"
    virtual_network_name = "Vikas_VNET"
    address_prefixes     = ["10.0.0.128/26"]
    location             = "central india"
  }

  subnet4 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "Vikas_RG"
    virtual_network_name = "Vikas_VNET"
    address_prefixes     = ["10.0.0.192/26"]
    location             = "central india"
  }
}

network_interface_data = {
  nic1 = {
    name                = "VM1_NIC"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    subnet_key          = "subnet1"
  }

  nic2 = {
    name                = "VM2_NIC"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    subnet_key          = "subnet2"
  }
}

virtual_machines_DATA = {

  vm1 = {
    name                = "VM1"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    size                = "Standard_D2s_V3"
    admin_username      = "Vikas"
    admin_password      = "Vikas@1234"
    nic_key             = "nic1"
  }

  vm2 = {
    name                = "VM2"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    size                = "Standard_D2s_V3"
    admin_username      = "Vikas"
    admin_password      = "Vikas@1234"
    nic_key             = "nic2"
  }
}


public_ip_DATA = {
  public_ip1 = {
    name                = "Application_Gateway_PublicIP"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    allocation_method   = "Static"
    sku                 = "Standard"
  }

  public_ip2 = {
    name                = "azure_bastion_publicIP"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    allocation_method   = "Static"
    sku                 = "Standard"
  }

  public_ip3 = {
    name                = "NAT_Gateway_PublicIP"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

bastion_host_data = {
  bastion1 = {
    name                  = "Azure_Bastion_Host"
    location              = "central india"
    resource_group_name   = "Vikas_RG"
    ip_configuration_name = "Azure_Bastion_IP_Configuration"
    subnet_key            = "subnet4"
    public_ip_key         = "public_ip2"
  }
}

nat_gateway_data = {
  nat1 = {
    name                = "NAT_Gateway"
    location            = "central india"
    resource_group_name = "Vikas_RG"
    sku_name            = "Standard"
    public_ip_key       = "public_ip3"
    subnet_keys         = ["subnet1", "subnet2"]
  }
}
