# Terraform Availability Set

resource "azurerm_availability_set" "availability_set" {
  name                         = "${var.availability_set_name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.product_rg_name}"
  platform_fault_domain_count  = "${var.platform_fault_domain_count}"
  platform_update_domain_count = "${var.platform_update_domain_count}"
  managed                      = "${var.availability_set_managed}"
}

# Terraform Load Balance 

resource "azurerm_lb" "lb" {
  name                = "${var.windows_vm_lb_name}"  
  resource_group_name = "${var.product_rg_name}"
  location            = "${var.location}"
  sku                 = "${var.windows_vm_lb_sku}"

  frontend_ip_configuration {
    name                          = "${var.windows_vm_lb_name}"
    subnet_id                     = "${data.azurerm_subnet.internal_subnet.id}"
    private_ip_address_allocation = "${var.private_ip_address_allocation}"
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name                = "${var.lb_backend_address_pool_name}"  
  resource_group_name = "${var.product_rg_name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "${var.lb_rule_name}"
  resource_group_name            = "${var.product_rg_name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  protocol                       = "${var.lb_rule_protocol}"
  frontend_port                  = "${var.lb_rule_frontend_port}"
  backend_port                   = "${var.lb_rule_backend_port}"
  frontend_ip_configuration_name = "${var.windows_vm_lb_name}"
  enable_floating_ip             = "${var.enable_floating_ip}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_backend_address_pool.id}"
  idle_timeout_in_minutes        = "${var.lb_rule_idle_timeout_in_minutes}"
}

# resource "azurerm_lb_rule" "lb_rule-2" {
#   name                           = "${var.lb_rule_name}-2"
#   resource_group_name            = "${var.product_rg_name}"
#   loadbalancer_id                = "${azurerm_lb.lb.id}"
#   protocol                       = "${var.lb_rule_protocol}"
#   frontend_port                  = "${var.lb_rule_frontend_port2}"
#   backend_port                   = "${var.lb_rule_backend_port2}"
#   frontend_ip_configuration_name = "${var.windows_vm_lb_name}"
#   enable_floating_ip             = false
#   backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb_backend_address_pool.id}"
#   idle_timeout_in_minutes        = "${var.lb_rule_idle_timeout_in_minutes}"
# }

# Terraform Network Interface

resource "azurerm_network_interface" "windows_vm_network_interface" {
  count               = "${var.windows_vm_count}"
  name                = "${var.windows_vm_name}0${count.index + 1}"
  location            = "${var.location}"
  resource_group_name = "${var.product_rg_name}"

  ip_configuration {
    name                          = "${var.windows_vm_name}0${count.index + 1}"
    subnet_id                     = "${data.azurerm_subnet.internal_subnet.id}"
    private_ip_address_allocation = "${var.windows_vm_network_interface_private_ip_address_allocation}"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "network_interface_backend_address_pool_association" {
  count                   = "${var.windows_vm_count}"
  network_interface_id    = "${element(azurerm_network_interface.windows_vm_network_interface.*.id, count.index)}"
  ip_configuration_name   = "${var.windows_vm_name}0${count.index + 1}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.lb_backend_address_pool.id}"
}

# Terraform Virtual Machine

locals {
  custom_data_params  = "Param($ComputerName = \"${var.windows_vm_name}0\")"
  custom_data_content = "${local.custom_data_params} ${file("./files/winrm.ps1")}"
}

resource "azurerm_virtual_machine" "windows_vm" {
  count                 = "${var.windows_vm_count}"
  name                  = "${var.windows_vm_name}0${count.index + 1}"
  location              = "${var.location}"
  resource_group_name   = "${var.product_rg_name}"
  network_interface_ids = ["${element(azurerm_network_interface.windows_vm_network_interface.*.id, count.index)}"]
  vm_size               = "${var.windows_vm_size}"
  availability_set_id   = "${azurerm_availability_set.availability_set.id}"

  delete_os_disk_on_termination     = true

  delete_data_disks_on_termination  = true

  storage_image_reference {
    publisher = "${var.windows_vm_storage_image_reference_publisher}"
    offer     = "${var.windows_vm_storage_image_reference_offer}"
    sku       = "${var.windows_vm_storage_image_reference_sku}"
    version   = "${var.windows_vm_storage_image_reference_version}"
  }

  storage_os_disk {
    name              = "${var.windows_vm_name}0${count.index + 1}"
    caching           = "${var.windows_vm_storage_os_disk_caching}"
    create_option     = "${var.windows_vm_storage_os_create_option}"
    managed_disk_type = "${var.windows_vm_storage_os_managed_disk_type}"
  }

  os_profile {
    computer_name  = "${var.windows_vm_name}0${count.index + 1}"
    admin_username = "${var.windows_vm_os_profile_admin_username}"
    admin_password = "${var.windows_vm_os_profile_admin_password}"
    custom_data    = "${local.custom_data_content}"
  }

  os_profile_windows_config {
    provision_vm_agent  = true
    timezone            = "UTC"

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.windows_vm_os_profile_admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.windows_vm_os_profile_admin_username}</Username></AutoLogon>"
    }

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = "${file("./files/FirstLogonCommands.xml")}"
    }
  }

}