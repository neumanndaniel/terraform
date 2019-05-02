output "fqdn" {
  value = "${azurerm_kubernetes_cluster.k8s.fqdn}"
}
output "id" {
  value = "${azurerm_kubernetes_cluster.k8s.id}"
}