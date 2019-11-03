variable "resource_group_name" {
  description = "Name of the Storage Account resource group"
  type        = string
}

variable "location" {
  description = "Azure region of the Storage Account"
  type        = string
}

variable "name" {
  description = "The name of the Storage Account"
  type        = string
}

variable "kind" {
  description = "The kind of the Storage Account"
  type        = string
}

variable "tier" {
  description = "The tier of the Storage Account"
  type        = string
}

variable "replication_type" {
  description = "The replication type of the Storage Account"
  type        = string
}

variable "access_tier" {
  description = "The access tier of the Storage Account"
  type        = string
}
