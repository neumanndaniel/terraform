variable "name" {
  description = "The name of continuous export configuration"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the continuous export configuration is created"
  type        = string
}

variable "location" {
  description = "The Azure region in which the continuous export configuration is created"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The resource id of the Log Analytics workspace"
}
