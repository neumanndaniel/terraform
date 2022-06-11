resource "azurerm_resource_group" "rg" {
  for_each = var.resource_group == true ? toset([var.resource_group_name]) : toset([])
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_management_lock" "lock" {
  for_each   = var.lock == true && var.resource_group == true ? toset([var.resource_group_name]) : toset([])
  name       = "rg-level"
  scope      = azurerm_resource_group.rg[var.resource_group_name].id
  lock_level = "CanNotDelete"
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group == true ? azurerm_resource_group.rg[var.resource_group_name].name : var.resource_group_name
  location                 = var.resource_group == true ? azurerm_resource_group.rg[var.resource_group_name].location : var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  dynamic "identity" {
    for_each = var.identity == true ? toset([var.storage_account_name]) : toset([])
    content {
      type = "SystemAssigned"
    }
  }
}
