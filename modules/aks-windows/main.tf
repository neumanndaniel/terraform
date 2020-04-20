####################
# Provider section #
####################
provider "azurerm" {
  version = "~> 2.4.0"
}

provider "azuread" {
  version = ">= 0.6"
}

provider "kubernetes" {
  version = ">= 1.9"

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
  version = ">= 2.2"
}

provider "null" {}
########################
# Data sources section #
########################
data "azuread_group" "aks" {
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

resource "azurerm_kubernetes_cluster" "aks" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  dns_prefix                      = var.name
  kubernetes_version              = var.kubernetes_version
  node_resource_group             = "${var.name}-worker"
  api_server_authorized_ip_ranges = var.api_auth_ips

  windows_profile {
    admin_username = "azureuser"
    admin_password = random_password.aks.result
  }

  default_node_pool {
    name                = substr(var.default_node_pool.name, 0, 12)
    node_count          = var.default_node_pool.node_count
    vm_size             = var.default_node_pool.vm_size
    type                = "VirtualMachineScaleSets"
    availability_zones  = var.default_node_pool.zones
    max_pods            = 250
    os_disk_size_gb     = 128
    vnet_subnet_id      = var.vnet_subnet_id
    node_taints         = var.default_node_pool.taints
    enable_auto_scaling = var.default_node_pool.cluster_auto_scaling
    min_count           = var.default_node_pool.cluster_auto_scaling_min_count
    max_count           = var.default_node_pool.cluster_auto_scaling_max_count
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
    azure_policy {
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

resource "null_resource" "aks" {
  triggers = {
    aks_kubernetes_version = azurerm_kubernetes_cluster.aks.kubernetes_version
  }

  provisioner "local-exec" {
    command     = "./cluster-upgrade-fix.sh ${var.name} ${var.resource_group_name}"
    working_dir = path.module
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each = var.additional_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = each.value.node_os == "Windows" ? substr(each.key, 0, 6) : substr(each.key, 0, 12)
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  availability_zones    = each.value.zones
  max_pods              = 250
  os_disk_size_gb       = 128
  os_type               = each.value.node_os
  vnet_subnet_id        = var.vnet_subnet_id
  node_taints           = each.value.taints
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
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

resource "azurerm_role_assignment" "aks_acr" {
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
    name      = data.azuread_group.aks.id
  }
}
