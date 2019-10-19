variable "resource_group_name" {
  description = "Name of the ACR resource group"
  type        = string
}

variable "location" {
  description = "Azure region of the ACR"
  type        = string
}

variable "name" {
  description = "The name of the ACR"
  type        = string
}

variable "sku" {
  description = "The SKU of the ACR"
  type        = string
}

variable "admin" {
  description = "Admin access enabled"
  type        = bool
}

variable "geo_replication" {
  description = "Azure regions for ACR geo replication"
  type        = list(string)
}
