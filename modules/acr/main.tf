#####################
# Providers section #
#####################
provider "azurerm" {
  version = "~> 2.0.0"
  features {}
}
#####################
# Resources section #
#####################
resource "azurerm_resource_group" "acr" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                     = var.name
  resource_group_name      = azurerm_resource_group.acr.name
  location                 = azurerm_resource_group.acr.location
  sku                      = var.sku
  admin_enabled            = var.admin
  georeplication_locations = var.geo_replication
}
