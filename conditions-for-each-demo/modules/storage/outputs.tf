output "resource_group_name" {
  value = var.resource_group == true ? azurerm_resource_group.rg[var.resource_group_name].name : null
}

output "storage_account_id" {
  value = azurerm_storage_account.storage.id
}

output "identity" {
  value = var.identity == true ? azurerm_storage_account.storage.identity.0.principal_id : null
}
