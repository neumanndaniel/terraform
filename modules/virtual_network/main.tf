####################
# Provider section #
####################
provider "azurerm" {
  version = "~> 2.0.0"
  features {}
}
#####################
# Resources section #
#####################
resource "azurerm_resource_group" "network" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "network" {
  name                = var.name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  subnet {
    name           = var.subnet_name
    address_prefix = var.subnet_address_space
  }
}
