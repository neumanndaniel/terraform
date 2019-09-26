variable "log_analytics_workspace_id" {
  default = "/subscriptions/REDACTED/resourcegroups/operations-management/providers/microsoft.operationalinsights/workspaces/REDACTED"
}

variable "kubernetes_version" {
  default = "1.14.6"
}

variable "key_vault_name" {
  default = "REDACTED"
}

variable "key_vault_resource_group_name" {
  default = "REDACTED"
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
  default = "aks"
}

variable "cluster_name" {
  default = "aks"
}

variable "resource_group_name" {
  default = "aks"
}

variable "location" {
  default = "North Europe"
}

variable "max_pods" {
  default = 250
}

variable "os_disk_size_gb" {
  default = 128
}

variable "vm_type" {
  default = "VirtualMachineScaleSets"
}

variable "zones" {
  default = ["1", "2", "3"]
}

variable "vnet_subnet_id" {
  default = "/subscriptions/REDACTED/resourceGroups/aks/providers/Microsoft.Network/virtualNetworks/aks-vnet/subnets/aks-subnet"
}

variable "network_plugin" {
  default = "azure"
}

variable "network_policy" {
  default = "azure"
}

variable "lb_sku" {
  default = "standard"
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

variable "cluster_role_binding_name" {
  default = "aks-cluster-admins"
}

variable "aad_group_guid" {
  default = "REDACTED"
}
