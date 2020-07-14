output "fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "mi_principal_id" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "mi_tenant_id" {
  value = azurerm_kubernetes_cluster.aks.identity[0].tenant_id
}

output "kubelet_client_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
}

output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "kubelet_user_assigned_identity_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].user_assigned_identity_id
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_admin_config[0].host
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config[0].cluster_ca_certificate
  sensitive = true
}
