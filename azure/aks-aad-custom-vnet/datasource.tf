data "azurerm_key_vault_secret" "ssh" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "spid" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "spsecret" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadclient" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadserver" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadserversecret" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}

data "azurerm_key_vault_secret" "aadtenant" {
  name      = "REDACTED"
  vault_uri = "${var.vault_uri}"
}
