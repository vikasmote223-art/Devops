module "resource_group" {
  source          = "../Child_module/Resource_group"
  resource_groups = var.resource_groups_Data
}

module "Vnet" {
  depends_on       = [module.resource_group]
  source           = "../Child_module/Vnet"
  virtual_networks = var.virtual_networks_Data
}

module "subnet" {
  depends_on = [module.Vnet]
  source     = "../Child_module/subnet"
  subnets    = var.subnets_Data
}
module "NIC" {
  depends_on         = [module.subnet]
  source             = "../Child_module/NIC"
  network_interfaces = var.network_interfaces_Data
}
