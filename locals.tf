locals {
  key_vault_role_assignments = merge(var.role_assignments, var.client_administrator_access ? {
    role_definition_name = "Key Vault Administrator"
    principal_id         = data.azurerm_client_config.current.object_id
  } : {})
}