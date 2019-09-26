data "azurerm_key_vault" "k8s" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "ssh" {
  name      = "sshpublic"
  key_vault_id = data.azurerm_key_vault.k8s.id
}

data "azurerm_key_vault_secret" "spid" {
  name      = "aksspid"
  key_vault_id = data.azurerm_key_vault.k8s.id
}

data "azurerm_key_vault_secret" "spsecret" {
  name      = "aksspsecret"
  key_vault_id = data.azurerm_key_vault.k8s.id
}

data "azurerm_key_vault_secret" "aadclient" {
  name      = "aadClientAppId"
  key_vault_id = data.azurerm_key_vault.k8s.id
}

data "azurerm_key_vault_secret" "aadserver" {
  name      = "aadServerAppId"
  key_vault_id = data.azurerm_key_vault.k8s.id
}

data "azurerm_key_vault_secret" "aadserversecret" {
  name      = "aadServerAppSecret"
  key_vault_id = data.azurerm_key_vault.k8s.id
}

data "azurerm_key_vault_secret" "aadtenant" {
  name      = "aadTenantId"
  key_vault_id = data.azurerm_key_vault.k8s.id
}
