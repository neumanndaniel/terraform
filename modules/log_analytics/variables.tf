variable "name" {
  description = "The name of the Log Analytics workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Log Analytics workspace resource group"
  type        = string
}

variable "location" {
  description = "Azure region of the Log Analytics workspace"
  type        = string
}

variable "sku" {
  description = "The SKU of the Log Analytics workspace"
  type        = string
}

variable "retention" {
  description = "The retention time of the Log Analytics workspace"
  type        = number
}
