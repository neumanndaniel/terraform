####################
# Provider section #
####################
provider "azurerm" {
  version = ">= 2.0.0"
  features {}
}
#####################
# Resources section #
#####################
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention
}

resource "azurerm_log_analytics_solution" "log_analytics" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.log_analytics.location
  resource_group_name   = azurerm_log_analytics_workspace.log_analytics.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.log_analytics.id
  workspace_name        = azurerm_log_analytics_workspace.log_analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
