output "key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "key_vault_cmkrsa_keyname" {
  value       = one(azurerm_key_vault_key.cmkrsa[*].name)
  description = "CMK RSA Key Name"
}

output "key_vault_cmkrsa_id" {
  value       = one(azurerm_key_vault_key.cmkrsa[*].id)
  description = "CMK RSA Key ID"
}
