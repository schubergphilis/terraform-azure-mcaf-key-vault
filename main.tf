data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  resource_group_name             = var.resource_group_name
  location                        = var.location
  name                            = var.name
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  purge_protection_enabled        = var.purge_protection
  soft_delete_retention_days      = var.soft_delete_retention_days
  public_network_access_enabled   = var.public_network_access_enabled

  network_acls {
    default_action             = length(var.ip_rules) == 0 && length(var.subnet_ids) == 0 ? var.default_network_action : "Deny"
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = var.subnet_ids
    bypass                     = var.network_bypass
  }

  tags = merge(var.tags, var.tags, {
    "Resource Type" = "Key vault"
  })
}

resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  scope                            = azurerm_key_vault.this.id
  role_definition_name             = each.value.role_definition_name
  principal_id                     = each.value.principal_id
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
  principal_type                   = each.value.principal_type
}