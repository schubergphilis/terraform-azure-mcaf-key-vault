output "key_vault_id" {
  value = azurerm_key_vault.this.id
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "cmkrsa_key_name" {
  value       = one(azurerm_key_vault_key.customer_managed_key_rsa[*].name)
  description = "CMK RSA Key Name"
}

output "cmkrsa_id" {
  value       = one(azurerm_key_vault_key.customer_managed_key_rsa[*].id)
  description = "CMK RSA Key ID"
}

output "cmkrsa_versionless_id" {
  value       = one(azurerm_key_vault_key.customer_managed_key_rsa[*].versionless_id)
  description = "CMK RSA Key Versionless ID"
}

output "cmkrsa_resource_versionless_id" {
  value       = one(azurerm_key_vault_key.customer_managed_key_rsa[*].resource_versionless_id)
  description = "CMK RSA Key Versionless Resource ID"
}

output "cmkrsa_resource_resource_id" {
  value       = one(azurerm_key_vault_key.customer_managed_key_rsa[*].resource_id)
  description = "CMK RSA Key Resource ID"
}
