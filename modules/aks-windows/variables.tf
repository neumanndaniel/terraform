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

variable "aad_client_application_id" {
  description = "Client application id for AAD integration"
  type        = string
}

variable "aad_server_application_id" {
  description = "Server application id for AAD integration"
  type        = string
}

variable "aad_server_application_secret" {
  description = "Server application secret for AAD integration"
  type        = string
}

variable "aad_tenant_id" {
  description = "AAD tenant id for AAD integration"
  type        = string
}

variable "aad_group_name" {
  description = "Name of the Azure AD group for cluster-admin access"
  type        = string
}

variable "agent_pool_configuration" {
  description = "The list object to configure one or several node pools with number of worker nodes, worker node VM size and Availability Zones."
  type = list(object({
    agent_count = number
    vm_size     = string
    zones       = list(string)
    agent_os    = string
    taints      = list(string)
  }))
}
