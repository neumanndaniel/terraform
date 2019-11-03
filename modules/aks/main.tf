####################
# Provider section #
####################
provider "azurerm" {
  version = "~> 1.35"
}

provider "azuread" {
  version = "~> 0.6"
}

provider "kubernetes" {
  version = "~> 1.9"

  host = azurerm_kubernetes_cluster.aks.kube_admin_config[0].host
  client_certificate = base64decode(
    azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_certificate,
  )
  client_key = base64decode(
    azurerm_kubernetes_cluster.aks.kube_admin_config[0].client_key,
  )
  cluster_ca_certificate = base64decode(
    azurerm_kubernetes_cluster.aks.kube_admin_config[0].cluster_ca_certificate,
  )
}

provider "random" {
  version = "~> 2.2"
}
########################
# Data sources section #
########################
data "azuread_group" "aks_cluster_admin" {
  name = var.aad_group_name
}
#####################
# Resources section #
#####################
resource "random_password" "aks" {
  length  = 20
  special = true
}

resource "azuread_application" "aks" {
  name = var.name
}

resource "azuread_service_principal" "aks" {
  application_id = azuread_application.aks.application_id
}

resource "azuread_service_principal_password" "aks" {
  service_principal_id = azuread_service_principal.aks.id
  value                = random_password.aks.result
  end_date_relative    = "8760h"
}

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = var.name
  kubernetes_version  = var.kubernetes_version
  node_resource_group = "${var.name}-worker"

  dynamic "agent_pool_profile" {
    for_each = var.agent_pool_configuration
    content {
      name               = format("nodepool%d", agent_pool_profile.key + 1)
      count              = agent_pool_profile.value["agent_count"]
      vm_size            = agent_pool_profile.value["vm_size"]
      type               = "VirtualMachineScaleSets"
      availability_zones = agent_pool_profile.value["zones"]
      max_pods           = 250
      os_type            = "Linux"
      os_disk_size_gb    = 128
      vnet_subnet_id     = var.vnet_subnet_id
    }
  }

  service_principal {
    client_id     = azuread_service_principal.aks.application_id
    client_secret = azuread_service_principal_password.aks.value
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      client_app_id     = var.aad_client_application_id
      server_app_id     = var.aad_server_application_id
      server_app_secret = var.aad_server_application_secret
      tenant_id         = var.aad_tenant_id
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
    kube_dashboard {
      enabled = false
    }
  }

  network_profile {
    load_balancer_sku  = "standard"
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
  }
}

resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azuread_service_principal.aks.id
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azuread_service_principal.aks.id
}

resource "azurerm_role_assignment" "acr" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPull"
  principal_id         = azuread_service_principal.aks.id
}

resource "kubernetes_cluster_role_binding" "aks" {
  metadata {
    name = "aks-cluster-admins"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = data.azuread_group.aks_cluster_admin.id
  }
}
