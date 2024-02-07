data "azurerm_client_config" "current" {
}

resource "azurerm_security_center_automation" "continuous_export" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  enabled = true

  action {
    type        = "loganalytics"
    resource_id = var.log_analytics_workspace_id
  }

  source {
    event_source = "Alerts"
    rule_set {
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "high"
        property_type  = "String"
      }
    }
    rule_set {
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "medium"
        property_type  = "String"
      }
    }
    rule_set {
      rule {
        property_path  = "Severity"
        operator       = "Equals"
        expected_value = "low"
        property_type  = "String"
      }
    }
  }

  scopes = ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"]
}
