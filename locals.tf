locals {

  key_vault_administrators_assignments = setunion(toset([for v in var.key_vault_administrators : merge(v, {
    role_definition_name = "Key Vault Administrator"
    })]), [{
    principal_id                     = data.azurerm_client_config.current.object_id
    role_definition_name             = "Key Vault Administrator"
    skip_service_principal_aad_check = false
  }])

  key_vault_crypto_users_assignments = toset([for v in var.key_vault_crypto_users : merge(v, {
    role_definition_name = "Key Vault Crypto User"
  })])

  key_vault_secret_users_assignments = toset([for v in var.key_vault_secret_users : merge(v, {
    role_definition_name = "Key Vault Secret User"
  })])

  key_vault_certificate_users_assignments = toset([for v in var.key_vault_certificate_users : merge(v, {
    role_definition_name = "Key Vault Certificate User"
  })])

  role_assignments = setunion(local.key_vault_administrators_assignments,
    local.key_vault_certificate_users_assignments,
    local.key_vault_crypto_users_assignments,
  local.key_vault_secret_users_assignments)
}