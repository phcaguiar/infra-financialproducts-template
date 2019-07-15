data "azurerm_lb" "aks_lb" {
  name                = "${var.lb_name}"
  resource_group_name = "${var.lb_aks_tribe_resource_group_name}"
}

data "azurerm_subnet" "internal_subnet" {
  name                 = "${var.internal_subnet_name}"
  virtual_network_name = "${var.virtual_network_name}"
  resource_group_name  = "${var.vnet_tribe_resource_group_name}"
}