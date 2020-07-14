variable "container_registry_id" {
  description = "Resource id of the ACR"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Resource id of the Log Analytics workspace"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the AKS cluster resource group"
  type        = string
}

variable "location" {
  description = "Azure region of the AKS cluster"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Resource id of the Virtual Network subnet"
  type        = string
}

variable "aad_group_name" {
  description = "Name of the Azure AD group for cluster-admin access"
  type        = string
}

variable "api_auth_ips" {
  description = "Whitelist of IP addresses that are allowed to access the AKS Master Control Plane API"
  type        = list(string)
}

variable "private_cluster" {
  description = "Deploy an AKS cluster without a public accessible API endpoint."
  type        = bool
}

variable "sla_sku" {
  description = "Define the SLA under which the managed master control plane of AKS is running."
  type        = string
}

variable "default_node_pool" {
  description = "The object to configure the default node pool with number of worker nodes, worker node VM size and Availability Zones."
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  })
}

variable "additional_node_pools" {
  description = "The map object to configure one or several additional node pools with number of worker nodes, worker node VM size and Availability Zones."
  type = map(object({
    node_count                     = number
    vm_size                        = string
    zones                          = list(string)
    labels                         = map(string)
    taints                         = list(string)
    node_os                        = string
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
  }))
}

variable "addons" {
  description = "Defines which addons will be activated."
  type = object({
    oms_agent            = bool
    kubernetes_dashboard = bool
    azure_policy         = bool
  })
}
