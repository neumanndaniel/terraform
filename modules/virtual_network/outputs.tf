output "id" {
  value = azurerm_virtual_network.network.id
}

output "subnet_id" {
  value = element(azurerm_virtual_network.network.subnet.*.id, 0)
}
