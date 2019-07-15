resource "azurerm_sql_server" "sql_server" {
  name                          = "${var.sql_server_name}"
  resource_group_name           = "${var.product_rg_name}"
  location                      = "${var.location}"
  version                       = "${var.sql_server_version}"
  administrator_login           = "${var.sql_server_administrator_login}"
  administrator_login_password  = "${var.sql_server_administrator_login_password}"
}

resource "azurerm_sql_database" "sql_server_database" {
  count                             = "${var.create_sql_server_database ? 1 : 0}"
  location                          = "${var.location}"
  resource_group_name               = "${var.product_rg_name}"
  server_name                       = "${azurerm_sql_server.sql_server.name}"
  name                              = "${var.sql_server_database_name}"
  edition                           = "${var.sql_server_database_edition}"
  collation                         = "${var.sql_server_database_collation}"
  create_mode                       = "${var.sql_server_database_create_mode}"
  requested_service_objective_name  = "${var.sql_server_database_requested_service_objective_name}"
}

resource "azurerm_sql_virtual_network_rule" "sql_virtual_network_rule" {
  name                = "${var.sql_virtual_network_rule_name}"
  resource_group_name = "${var.product_rg_name}"
  server_name         = "${azurerm_sql_server.sql_server.name}"
  subnet_id           = "${data.azurerm_subnet.internal_subnet.id}"
}

