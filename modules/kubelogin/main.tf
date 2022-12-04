terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.32.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.30.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.16.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

data "azurerm_kubernetes_cluster" "aks" {
  name                = "azure-kubernetes-service"
  resource_group_name = "azure-kubernetes-service"
}

data "azurerm_key_vault" "kv" {
  name                = "azure-key-vault"
  resource_group_name = "azure-key-vault"
}

data "azurerm_key_vault_secret" "id" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "kubernetes-id"
}

data "azurerm_key_vault_secret" "secret" {
  key_vault_id = data.azurerm_key_vault.kv.id
  name         = "kubernetes-secret"
}

data "azuread_service_principal" "aks" {
  display_name = "Azure Kubernetes Service AAD Server"
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  cluster_ca_certificate = base64decode(
    data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "./modules/exec/kubelogin"
    args = [
      "get-token",
      "--login",
      "spn",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      data.azurerm_kubernetes_cluster.aks.azure_active_directory_role_based_access_control[0].tenant_id,
      "--server-id",
      data.azuread_service_principal.aks.application_id,
      "--client-id",
      data.azurerm_key_vault_secret.id.value,
      "--client-secret",
      data.azurerm_key_vault_secret.secret.value
    ]
  }
}

data "kubernetes_namespace" "kube_system" {
  metadata {
    name = "kube-system"
  }
}

output "namespace_uid" {
  value = data.kubernetes_namespace.kube_system.metadata[0].uid
}

output "namespace_name" {
  value = data.kubernetes_namespace.kube_system.metadata[0].name
}
