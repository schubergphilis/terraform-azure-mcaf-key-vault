output "key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

# output "key_vault_cmkrsa_keyname" {
#   value       = var.key_vault.cmk_keys_create ? azurerm_key_vault_key.cmkrsa[count.index].name : null
#   description = "CMK RSA Key Name"
# }

# output "key_vault_cmkrsa_id" {
#   value       = var.key_vault.cmk_keys_create ? azurerm_key_vault_key.cmkrsa[count.index].id : null
#   description = "CMK RSA Key ID"
# }

# output "key_vault_cmkec_keyname" {
#   value       = var.key_vault.cmk_keys_create ? azurerm_key_vault_key.cmkec[count.index].name : null
#   description = "CMK EC Key Name"
# }

# output "key_vault_cmkec_id" {
#   value       = var.key_vault.cmk_keys_create ? azurerm_key_vault_key.cmkec[count.index].id : null
#   description = "CMK EC Key ID"
# }