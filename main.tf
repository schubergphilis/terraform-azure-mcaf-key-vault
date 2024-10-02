data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Resource Group"
    })
  )
}

resource "azurerm_key_vault" "this" {
  resource_group_name             = var.key_vault.resource_group_name == null ? azurerm_resource_group.this.name : var.key_vault.resource_group_name
  location                        = var.key_vault.location == null ? azurerm_resource_group.this.location : var.key_vault.location
  name                            = var.key_vault.name
  tenant_id                       = var.key_vault.tenant_id
  sku_name                        = var.key_vault.sku
  enabled_for_disk_encryption     = var.key_vault.enabled_for_disk_encryption
  enabled_for_deployment          = var.key_vault.enabled_for_deployment
  enabled_for_template_deployment = var.key_vault.enabled_for_template_deployment
  enable_rbac_authorization       = var.key_vault.enable_rbac_authorization
  purge_protection_enabled        = var.key_vault.purge_protection
  soft_delete_retention_days      = var.key_vault.soft_delete_retention_days

  network_acls {
    default_action             = length(var.key_vault.ip_rules) == 0 && length(var.key_vault.subnet_id) == 0 ? "Allow" : "Deny"
    ip_rules                   = var.key_vault.ip_rules
    virtual_network_subnet_ids = var.key_vault.subnet_id
    bypass                     = var.key_vault.network_bypass
  }

  tags = merge(
    try(var.tags),
    tomap({
      "Resource Type" = "Key vault"
    })
  )
}

resource "azurerm_role_assignment" "this" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_key" "cmkrsa" {
  count = var.key_vault.cmk_keys_create ? 1 : 0

  name         = var.key_vault.cmkrsa_keyname
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts = [
    "unwrapKey",
    "wrapKey"
  ]

  rotation_policy {
    automatic {
      time_after_creation = var.key_vault.cmk_rotation_period
    }
  }

  depends_on = [
    azurerm_role_assignment.this
  ]
}

resource "azurerm_key_vault_key" "this" {
  for_each = var.key_vault_key != null ? var.key_vault_key : {}

  key_opts        = each.value.opts
  key_type        = each.value.type
  key_vault_id    = azurerm_key_vault.this.id
  name            = each.value.name == null ? each.key : each.value.name
  curve           = each.value.curve
  expiration_date = each.value.expiration_date
  key_size        = each.value.size
  not_before_date = each.value.not_before_date
  tags            = each.value.tags

  dynamic "rotation_policy" {
    for_each = each.value.rotation_policy != null ? [each.value.rotation_policy] : []
    content {
      expire_after         = rotation_policy.value.expire_after
      notify_before_expiry = rotation_policy.value.notify_before_expiry

      automatic {
        time_before_expiry = rotation_policy.value.automatic.time_before_expiry
      }
    }
  }

  depends_on = [
    azurerm_role_assignment.this
  ]
}