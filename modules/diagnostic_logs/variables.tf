variable "name" {
  description = "The name of the diagnostic logs configuration"
  type        = string
}

variable "target_resource_id" {
  description = "The resource id of the target resource for which diagnostic logs will be enabled"
  type        = string
}

variable "storage_account_id" {
  description = "The resource id of the Storage Account where the diagnostic logs will be stored"
  type        = string
}

variable "diagnostic_logs" {
  description = "The list of diagnostic logs that should be enabled"
  type        = list(string)
}

variable "retention" {
  description = "The retention time for all diagnostic logs"
  type        = number
}
