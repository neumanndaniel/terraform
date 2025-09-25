terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.6"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44"
    }
  }
}
