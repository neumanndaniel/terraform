####################
# Provider section #
####################
provider "azurerm" {
  version = ">= 2.0.0"
  features {}
}
#####################
# Resources section #
#####################
resource "azurerm_container_registry" "acr" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                      = var.sku
  admin_enabled            = var.admin
  georeplication_locations = var.geo_replication
}
