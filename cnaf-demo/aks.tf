resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

data "azurerm_key_vault_secret" "ssh" {
  name      = "sshpublic"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "spid" {
  name      = "aksspid"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "spsecret" {
  name      = "aksspsecret"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadclient" {
  name      = "aadClientAppId"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadserver" {
  name      = "aadServerAppId"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadserversecret" {
  name      = "aadServerAppSecret"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadtenant" {
  name      = "aadTenantId"
  vault_uri = "${var.vault_uri}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kubernetes_version}"

  depends_on = [
    "azurerm_resource_group.k8s",
    "data.azurerm_key_vault_secret.aadclient",
    "data.azurerm_key_vault_secret.aadserver",
    "data.azurerm_key_vault_secret.aadtenant",
    "data.azurerm_key_vault_secret.spid",
    "data.azurerm_key_vault_secret.spsecret",
    "data.azurerm_key_vault_secret.ssh",
  ]

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      key_data = "${data.azurerm_key_vault_secret.ssh.value}"
    }
  }

  agent_pool_profile {
    name            = "agentpool"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_size}"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${data.azurerm_key_vault_secret.spid.value}"
    client_secret = "${data.azurerm_key_vault_secret.spsecret.value}"
  }

  role_based_access_control {
    azure_active_directory {
      client_app_id     = "${data.azurerm_key_vault_secret.aadclient.value}"
      server_app_id     = "${data.azurerm_key_vault_secret.aadserver.value}"
      server_app_secret = "${data.azurerm_key_vault_secret.aadserversecret.value}"
      tenant_id         = "${data.azurerm_key_vault_secret.aadtenant.value}"
    }
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${var.log_analytics_workspace_id}"
    }
  }
}

resource "null_resource" "k8s" {
  depends_on = [
    "azurerm_kubernetes_cluster.k8s",
  ]

  provisioner "local-exec" {
    command = "az aks get-credentials --resource-group ${azurerm_resource_group.k8s.name} --name ${var.cluster_name} --admin"
  }
}

resource "kubernetes_cluster_role_binding" "k8s" {
  depends_on = [
    "azurerm_kubernetes_cluster.k8s",
    "null_resource.k8s",
  ]

  metadata {
    name = "azst-aks-cluster-admins"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "${var.add_group_guid}"
  }
}

resource "kubernetes_deployment" "aci-helloworld" {
  depends_on = [
    "azurerm_kubernetes_cluster.k8s",
    "null_resource.k8s",
  ]

  metadata {
    name = "aci-helloworld"

    labels {
      app = "aci-helloworld"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "aci-helloworld"
      }
    }

    template {
      metadata {
        labels {
          app = "aci-helloworld"
        }
      }

      spec {
        container {
          image = "microsoft/aci-helloworld"
          name  = "aci-helloworld"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "aci-helloworld-svc" {
  depends_on = [
    "azurerm_kubernetes_cluster.k8s",
    "null_resource.k8s",
  ]

  metadata {
    name = "aci-helloworld-svc"
  }

  spec {
    selector {
      app = "${kubernetes_deployment.aci-helloworld.spec.0.template.0.metadata.0.labels.app}"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
