data "azurerm_lb" "aks_lb" {
  name                = "${var.lb_name}"
  resource_group_name = "${var.lb_aks_tribe_resource_group_name}"
}
