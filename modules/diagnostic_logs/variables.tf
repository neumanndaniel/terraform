variable "name" {
  description = "The name of the diagnostic logs configuration"
  type        = string
}

variable "backend_type" {
  description = "The backend type where the diagnostic logs will be sent. Possible values are 'storage_account', or 'log_analytics'"
  type        = string
  validation {
    condition     = var.backend_type == "storage_account" || var.backend_type == "log_analytics"
    error_message = "The backend type must be either 'storage_account' or 'log_analytics'"
  }
}

variable "target_resource_id" {
  description = "The resource id of the target resource for which diagnostic logs will be enabled"
  type        = string
}

variable "storage_account_id" {
  description = "The resource id of the Storage Account where the diagnostic logs will be stored"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "The resource id of the Log Analytics workspace where the diagnostic logs will be stored"
  type        = string
  default     = null
}

variable "diagnostic_logs" {
  description = "The list of diagnostic logs that should be enabled"
  type        = list(string)
}
