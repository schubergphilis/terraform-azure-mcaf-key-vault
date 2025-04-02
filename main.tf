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


resource "azurerm_key_vault_key" "customer_managed_key_rsa" {
  count = var.customer_managed_key != null ? 1 : 0

  name         = var.customer_managed_key.rsa_key_name
  key_vault_id = azurerm_key_vault.this.id
  #checkov:skip=CKV_AZURE_112: Not all keys need to be HSM
  key_type = "RSA"
  key_size = var.customer_managed_key.rsa_key_size
  key_opts = [
    "unwrapKey",
    "wrapKey"
  ]
  expiration_date = var.customer_managed_key.expiration_date

  rotation_policy {
    automatic {
      time_after_creation = var.customer_managed_key.rotation_period
      time_before_expiry  = var.customer_managed_key.time_before_expiry
    }
    expire_after         = var.customer_managed_key.expiry_period
    notify_before_expiry = var.customer_managed_key.notify_period
  }

  depends_on = [
    azurerm_role_assignment.this
  ]
}

resource "azurerm_key_vault_key" "this" {
  for_each = var.keys != null ? var.keys : {}

  key_opts = each.value.opts
  #checkov:skip=CKV_AZURE_112: Not all keys need to be HS
  key_type        = each.value.type
  key_vault_id    = azurerm_key_vault.this.id
  name            = each.value.name == null ? each.key : each.value.name
  curve           = each.value.curve
  expiration_date = each.value.expiration_date
  key_size        = each.value.size
  not_before_date = each.value.not_before_date

  dynamic "rotation_policy" {
    for_each = each.value.rotation_policy != null ? [each.value.rotation_policy] : []
    content {
      expire_after         = rotation_policy.value.expire_after
      notify_before_expiry = rotation_policy.value.notify_before_expiry

      automatic {
        time_after_creation = rotation_policy.value.automatic.time_after_creation
        time_before_expiry  = rotation_policy.value.automatic.time_before_expiry
      }
    }
  }

  tags = merge(var.tags, {
    "Resource Type" = "Key vault key"
    },
  each.value.tags)

  depends_on = [
    azurerm_role_assignment.this
  ]
}
