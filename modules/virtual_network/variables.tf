variable "resource_group_name" {
  description = "Name of the Virtual Network resource group"
  type        = string
}

variable "location" {
  description = "Azure region of the Virtual Network"
  type        = string
}

variable "name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the Virtual Network subnet"
  type        = string
}

variable "address_space" {
  description = "The address space (CIDR notation) of the Virtual Network"
  type        = list(string)
}

variable "subnet_address_space" {
  description = "The address space (CIDR notation) of the Virtual Network subnet"
  type        = string
}

variable "dns_servers" {
  description = "The DNS servers"
  type        = list(string)
}
