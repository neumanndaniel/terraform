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
  default     = null
}

variable "type" {
  description = "The type of continuous export configuration"
  type        = string
  default     = "loganalytics"
  validation {
    condition     = var.type == "loganalytics" || var.type == "eventhub"
    error_message = "The type of continuous export configuration must be either 'loganalytics' or 'eventhub'"
  }
}

variable "eventhub_id" {
  description = "The resource id of the Event Hub"
  default     = null
}

variable "eventhub_connection_string" {
  description = "The connection string of the Event Hub"
  sensitive   = true
  default     = null
}
