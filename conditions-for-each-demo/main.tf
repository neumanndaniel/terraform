terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.9.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "storage1" {
  source               = "./modules/storage"
  resource_group_name  = "rg12345"
  location             = "northeurope"
  storage_account_name = "azcdmdn12345"
  lock                 = true
}

module "storage2" {
  source               = "./modules/storage"
  resource_group       = false
  resource_group_name  = module.storage1.resource_group_name
  location             = "westeurope"
  storage_account_name = "azcdmdn67890"
  identity             = true
}

output "storage_account_id_1" {
  value = module.storage1.storage_account_id
}

output "storage_account_id_2" {
  value = module.storage2.storage_account_id
}

output "identity_2" {
  value = module.storage2.identity
}
