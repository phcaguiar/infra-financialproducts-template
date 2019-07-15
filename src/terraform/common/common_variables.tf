variable "subscription_id" {
  description = "Tribe subscription id."
}

variable "common_tribe_resource_group_name" {
  description = "Common Tribe resource group name."
}

variable "app_name_list" {
  description = "List of the apps name."
  type        = "list"
}

variable "lb_name" {
  description = "The name of the aks loadbalancer."
}

variable "lb_aks_tribe_resource_group_name" {
  description = "The name of the tribe aks loadbalancer resource group."
}

variable "internal_subnet_name" {
  description = "Tribe internal subnet name."
}

variable "virtual_network_name" {
  description = "Tribe virtual network name."
}

variable "vnet_tribe_resource_group_name" {
  description = "Tribe virtual network resource group name."
}

variable "location" {
  description = "Azure Location."
}

variable "product_rg_name" {
  description = "Product resource group name."
}
