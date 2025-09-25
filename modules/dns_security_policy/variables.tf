variable "name" {
  description = "The name of the DNS Resolver Policy."
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group in which to create the DNS Resolver Policy."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "domain_list" {
  description = "A list of domains to include in the DNS Resolver Domain List."
  type = map(object({
    name    = string
    domains = list(string)
  }))
}

variable "rules" {
  description = "A list of DNS security rules to apply to the DNS Resolver Policy."
  type = map(object({
    name                    = string
    action_type             = string
    domain_list_keys        = list(string)
    dns_security_rule_state = string
    priority                = number
  }))
}

variable "vnet_links" {
  description = "A list of virtual network links to associate with the DNS Resolver Policy."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}

variable "tags" {
  description = "A mapping of tags to assign to the DNS Resolver Policy."
  type        = map(string)
  default     = {}
}
