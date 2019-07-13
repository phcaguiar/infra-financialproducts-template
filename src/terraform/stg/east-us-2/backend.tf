terraform {
  backend "azurerm" {
    resource_group_name  = "RESOURCE-GROUP-NAME"
    storage_account_name = "STOR-ACCOUNT-NAME"
    container_name       = "CONTAINER-NAME"
    key                  = "KEY-NAME"
  }
}
