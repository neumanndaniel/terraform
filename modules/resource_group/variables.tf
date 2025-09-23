variable "location" {
  description = "Azure region of the Resource Group"
  type        = string
}

variable "name" {
  description = "The name of the Resource Group"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource group."
  type        = map(string)
  default     = {}
}
