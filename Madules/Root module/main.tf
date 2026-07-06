module "resource_group" {
  source = "../resource_Group"
  RG     = var.resource_group_data
}

module "Vnet" {

  depends_on = [module.resource_group]
  source     = "../VNet"
  Vnet       = var.Vnet_data
}
module "subnet" {
  depends_on = [module.Vnet]
  source     = "../Subnet"
  subnet     = var.subnet_data
}
