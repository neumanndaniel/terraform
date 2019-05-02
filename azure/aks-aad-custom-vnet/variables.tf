variable "log_analytics_workspace_id" {
  default = "/subscriptions/REDACTED/resourcegroups/REDACTED/providers/microsoft.operationalinsights/workspaces/REDACTED"
}

variable "kubernetes_version" {
  default = "1.13.5"
}

variable "vault_uri" {
  default = "https://REDACTED.vault.azure.net/"
}

variable "agent_count" {
  default = 3
}

variable "vm_size" {
  default = "Standard_D2_v3"
}

variable "admin_username" {
  default = "REDACTED"
}

variable "dns_prefix" {
  default = "REDACTED"
}

variable "cluster_name" {
  default = "REDACTED"
}

variable "resource_group_name" {
  default = "REDACTED"
}

variable "location" {
  default = "North Europe"
}

variable "max_pods" {
  default = 110
}

variable "os_disk_size_gb" {
  default = 30
}

variable "vnet_subnet_id" {
  default = "/subscriptions/REDACTED/resourceGroups/REDACTED/providers/Microsoft.Network/virtualNetworks/REDACTED/subnets/REDACTED"
}

variable "network_plugin" {
  default = "azure"
}

variable "network_policy" {
  default = "calico"
}

variable "dns_service_ip" {
  default = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  default = "172.17.0.1/16"
}

variable "service_cidr" {
  default = "10.0.0.0/16"
}

variable "cluster_role_binding_name"{
  default = "REDACTED"
}

variable "aad_group_guid"{
  default = "REDACTED"
}