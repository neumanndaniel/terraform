resource "azurerm_monitor_diagnostic_setting" "diagnostic_logs_storage" {
  for_each           = var.backend_type == "storage_account" ? toset(["default"]) : []
  name               = "${var.name}-storage"
  target_resource_id = var.target_resource_id
  storage_account_id = var.storage_account_id

  dynamic "enabled_log" {
    for_each = var.diagnostic_logs
    content {
      category = enabled_log.value
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_logs_log_analytics" {
  for_each                       = var.backend_type == "log_analytics" ? toset(["default"]) : []
  name                           = "${var.name}-log-analytics"
  target_resource_id             = var.target_resource_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = var.diagnostic_logs
    content {
      category = enabled_log.value
    }
  }
}
