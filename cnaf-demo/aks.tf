resource "azurerm_resource_group" "k8s" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.cluster_name}"
  location            = "${azurerm_resource_group.k8s.location}"
  resource_group_name = "${azurerm_resource_group.k8s.name}"
  dns_prefix          = "${var.dns_prefix}"
  kubernetes_version  = "${var.kubernetes_version}"

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
    max_pods        = "${var.max_pods}"
    os_type         = "Linux"
    os_disk_size_gb = "${var.os_disk_size_gb}"
  }

  service_principal {
    client_id     = "${data.azurerm_key_vault_secret.spid.value}"
    client_secret = "${data.azurerm_key_vault_secret.spsecret.value}"
  }

  role_based_access_control {
    enabled = true

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

resource "kubernetes_cluster_role_binding" "k8s" {

  metadata {
    name = "${var.cluster_role_binding_name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "${var.aad_group_guid}"
  }
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
