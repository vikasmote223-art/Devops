module "resource_group" {

  source = "../Child_module/Resource_group"
  RG     = var.resource_group
}

module "vnet" {
  depends_on = [module.resource_group]
  source     = "../Child_module/VNET"
  VNET       = var.Vnet_DATA
}

module "subnet" {
  depends_on = [module.vnet]
  source     = "../Child_module/Subnet"
  Subnet     = var.Subnet_DATA
}


module "network_interface" {
  depends_on = [module.subnet]
  source     = "../Child_module/Network_interface_Card"

  network_interfaces = {
    for k, v in var.network_interface_data :
    k => merge(v, {
      subnet_id = module.subnet.subnet_id[v.subnet_key]
    })
  }
}
module "virtual_machine" {
  depends_on = [module.network_interface]
  source     = "../Child_module/Virtual_machin"

  virtual_machines = {
    for k, v in var.virtual_machines_DATA :
    k => merge(v, {
      network_interface_ids = module.network_interface.network_interface_ids[v.nic_key]
    })


  }

}

module "public_ip" {
  depends_on = [module.resource_group, module.vnet, module.subnet]
  source     = "../Child_module/public_IP"
  public_ip  = var.public_ip_DATA
}

module "bastion" {
  depends_on = [module.public_ip, module.subnet]
  source     = "../Child_module/Azure_bastion"

  bastion_host = {
    for k, v in var.bastion_host_data :
    k => merge(v, {
      subnet_id            = module.subnet.subnet_id[v.subnet_key]
      public_ip_address_id = module.public_ip.public_ip_ids[v.public_ip_key]
    })
  }
}

module "nat_gateway" {
  depends_on = [module.public_ip, module.subnet]
  source     = "../Child_module/NAT"

  nat_gateway = {
    for k, v in var.nat_gateway_data :
    k => merge(v, {
      subnet_id            = module.subnet.subnet_id[v.subnet_keys[0]]
      public_ip_address_id = module.public_ip.public_ip_ids[v.public_ip_key]
    })
  }
}


resource "azurerm_network_security_group" "vm_nsg" {
  depends_on          = [module.network_interface]
  name                = "VM_NSG"
  location            = "central india"
  resource_group_name = "Vikas_RG"

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
