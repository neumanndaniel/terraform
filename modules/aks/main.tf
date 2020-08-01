####################
# Provider section #
####################
provider "azurerm" {
  version = ">= 2.21.0"
  features {}
}

provider "azuread" {
  version = ">= 0.6"
}
########################
# Data sources section #
########################
data "azuread_group" "aks" {
  name = var.aad_group_name
}
#####################
# Resources section #
#####################
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
  private_cluster_enabled         = var.private_cluster
  sku_tier                        = var.sla_sku
  api_server_authorized_ip_ranges = var.api_auth_ips

  default_node_pool {
    name                  = substr(var.default_node_pool.name, 0, 12)
    orchestrator_version  = var.kubernetes_version
    node_count            = var.default_node_pool.node_count
    vm_size               = var.default_node_pool.vm_size
    type                  = "VirtualMachineScaleSets"
    availability_zones    = var.default_node_pool.zones
    max_pods              = 250
    os_disk_size_gb       = 128
    vnet_subnet_id        = var.vnet_subnet_id
    node_labels           = var.default_node_pool.labels
    node_taints           = var.default_node_pool.taints
    enable_auto_scaling   = var.default_node_pool.cluster_auto_scaling
    min_count             = var.default_node_pool.cluster_auto_scaling_min_count
    max_count             = var.default_node_pool.cluster_auto_scaling_max_count
    enable_node_public_ip = false
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true

    azure_active_directory {
      managed = true
      admin_group_object_ids = [
        data.azuread_group.aks.id
      ]
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = var.addons.oms_agent
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
    kube_dashboard {
      enabled = var.addons.kubernetes_dashboard
    }
    azure_policy {
      enabled = var.addons.azure_policy
    }
  }

  network_profile {
    load_balancer_sku  = "standard"
    outbound_type      = "loadBalancer"
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.0.0.0/16"
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
  orchestrator_version  = var.kubernetes_version
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  availability_zones    = each.value.zones
  max_pods              = 250
  os_disk_size_gb       = 128
  os_type               = each.value.node_os
  vnet_subnet_id        = var.vnet_subnet_id
  node_labels           = each.value.labels
  node_taints           = each.value.taints
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  enable_node_public_ip = false
}

resource "azurerm_role_assignment" "aks" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_subnet" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
