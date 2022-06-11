variable "resource_group" {
  type    = bool
  default = true
}

variable "resource_group_name" {}

variable "location" {}

variable "lock" {
  type    = bool
  default = false
}

variable "storage_account_name" {}

variable "identity" {
  type    = bool
  default = false
}
