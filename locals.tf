locals {

  key_vault_administrators_assignments = merge({ for k, v in var.key_vault_administrators : "${k}_admin" => merge(v, {
    role_definition_name = "Key Vault Administrator"
    }) },
    {
      deploy_admin = {
        principal_id                     = data.azurerm_client_config.current.object_id
        role_definition_name             = "Key Vault Administrator"
        skip_service_principal_aad_check = false
        principal_type                   = null
      }
  })

  key_vault_encryption_users = { for k, v in var.key_vault_encryption_users : "${k}_enc_users" => merge(v, {
    role_definition_name = "Key Vault Crypto Service Encryption User"
  }) }

  key_vault_crypto_users_assignments = { for k, v in var.key_vault_crypto_users : "${k}_crypto_users" => merge(v, {
    role_definition_name = "Key Vault Crypto User"
  }) }

  key_vault_secret_users_assignments = { for k, v in var.key_vault_secret_users : "${k}_secrets_users" => merge(v, {
    role_definition_name = "Key Vault Secret User"
  }) }

  key_vault_certificate_users_assignments = { for k, v in var.key_vault_certificate_users : "${k}_cert_users" => merge(v, {
    role_definition_name = "Key Vault Certificate User"
  }) }

  role_assignments = merge(local.key_vault_administrators_assignments,
    local.key_vault_certificate_users_assignments,
    local.key_vault_crypto_users_assignments,
    local.key_vault_secret_users_assignments,
  local.key_vault_encryption_users)

  should_create_pep_with_dns_zone_group = (
    var.private_endpoint != null &&
    var.private_endpoints_manage_dns_zone_group
  )

  should_create_pep_without_dns_zone_group = (
    var.private_endpoint != null &&
    !var.private_endpoints_manage_dns_zone_group
  )
}