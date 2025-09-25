locals {
  api_version = "2025-05-01"
  dns_resolver_domain_lists = {
    for rule_key, rule in var.rules : rule_key => [
      for domain_list_key in rule.domain_list_keys : {
        id = azapi_resource.dns_resolver_domain_list[domain_list_key].id
      }
    ]
  }
}

data "azurerm_virtual_network" "virtual_network" {
  for_each = var.vnet_links

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azapi_resource" "dns_resolver_policy" {
  type      = "Microsoft.Network/dnsResolverPolicies@${local.api_version}"
  parent_id = var.resource_group_id
  name      = var.name
  location  = var.location
  tags      = var.tags
  body = {
    properties = {
    }
  }
}

resource "azapi_resource" "dns_resolver_domain_list" {
  for_each = var.domain_list

  type      = "Microsoft.Network/dnsResolverDomainLists@${local.api_version}"
  parent_id = var.resource_group_id
  name      = each.value.name
  location  = var.location
  tags      = var.tags
  body = {
    properties = {
      domains = each.value.domains
    }
  }
}

resource "azapi_resource" "dns_resolver_policy_rule" {
  for_each   = var.rules
  depends_on = [azapi_resource.dns_resolver_domain_list]

  type      = "Microsoft.Network/dnsResolverPolicies/dnsSecurityRules@${local.api_version}"
  parent_id = azapi_resource.dns_resolver_policy.id
  name      = each.value.name
  location  = var.location
  tags      = var.tags
  body = {
    properties = {
      action = {
        actionType = each.value.action_type
      }
      dnsResolverDomainLists = local.dns_resolver_domain_lists[each.key]
      dnsSecurityRuleState   = each.value.dns_security_rule_state
      priority               = each.value.priority
    }
  }
}

resource "azapi_resource" "dns_resolver_vnet_link" {
  for_each = var.vnet_links

  type      = "Microsoft.Network/dnsResolverPolicies/virtualNetworkLinks@${local.api_version}"
  parent_id = azapi_resource.dns_resolver_policy.id
  name      = each.value.name
  location  = var.location
  tags      = var.tags
  body = {
    properties = {
      virtualNetwork = {
        id = data.azurerm_virtual_network.virtual_network[each.key].id
      }
    }
  }
}
