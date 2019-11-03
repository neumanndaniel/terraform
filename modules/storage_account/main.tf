####################
# Provider section #
####################
provider "azurerm" {
  version = "~> 1.35"
}
#####################
# Resources section #
#####################
resource "azurerm_resource_group" "storage" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                      = var.name
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_kind              = var.kind
  account_tier              = var.tier
  account_replication_type  = var.replication_type
  access_tier               = var.access_tier
  enable_blob_encryption    = true
  enable_file_encryption    = true
  enable_https_traffic_only = true
}
