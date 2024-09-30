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
  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
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
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_role_assignment.this
  ]
}

resource "azurerm_key_vault_key" "cmkec" {
  count = var.key_vault.cmk_keys_create ? 1 : 0

  name         = var.key_vault.cmkec_keyname
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "EC"
  curve        = "P-256"
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_role_assignment.this
  ]
}
