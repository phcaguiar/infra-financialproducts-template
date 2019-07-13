resource "azurerm_dns_a_record" "dns_record" {
  count               = "${length(var.app_name_list)}"
  name                = "${element(values(var.app_name_list[count.index]), 0)}"
  zone_name           = "${var.zone_name}"
  resource_group_name = "${var.common_tribe_resource_group_name}"
  ttl                 = "${var.ttl}"
  records             = ["${data.azurerm_lb.aks_lb.private_ip_address}"]
}
