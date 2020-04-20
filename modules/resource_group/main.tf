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
resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
}
