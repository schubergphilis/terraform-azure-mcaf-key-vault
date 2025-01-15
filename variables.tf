variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "location" {
  description = "Location of the resources to create"
  type        = string
}

variable "key_vault" {
  type = object({
    name                            = string
    tenant_id                       = optional(string, null)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    enable_rbac_authorization       = optional(bool, true)
    purge_protection_enabled        = optional(bool, true)
    soft_delete_retention_days      = optional(number, 30)
    public_network_access_enabled   = optional(bool, false)
    default_action                  = optional(string, "Deny")
    sku                             = optional(string, "standard")
    ip_rules                        = optional(list(string), [])
    virtual_network_subnet_ids      = optional(list(string), [])
    bypass                          = optional(string, "None")
    cmk_keys_create                 = optional(bool, false)
    cmkrsa_key_name                 = optional(string, "cmkrsa")
    cmkec_key_name                  = optional(string, "cmkec")
    cmk_rotation_period             = optional(string, "P18M")
    cmk_expiry_period               = optional(string, "P2Y")
    cmk_notify_period               = optional(string, "P30D")
    tags                            = optional(map(string), {})
  })
  nullable    = false
  description = <<KEY_VAULT_DESCRIPTION
This object describes the configuration for an Azure Key Vault.

The following arguments are supported:

- `name` - (Required) The name of the Key Vault.
- `tenant_id` - (Optional) The Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault.
- `enabled_for_disk_encryption` - (Optional) Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.
- `enabled_for_deployment` - (Optional) Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault.
- `enabled_for_template_deployment` - (Optional) Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault.
- `enable_rbac_authorization` - (Optional) Specifies whether Azure RBAC is permitted to retrieve secrets from the vault.
- `purge_protection` - (Optional) Specifies whether protection against purge is enabled for this Key Vault.
- `soft_delete_retention_days` - (Optional) The number of days that items should be retained for once soft deleted.
- `default_action` - (Optional) The default action to apply when no rules match from network_acls block.
- `sku` - (Optional) The SKU of the Key Vault. Default is `standard`.
- `ip_rules` - (Optional) List of IP addresses that are permitted to access the key vault.
- `subnet_ids` - (Optional) List of subnet IDs that are permitted to access the key vault.
- `network_bypass` - (Optional) Specifies which traffic can bypass the network rules. Possible values are `AzureServices` and `None`.
- `cmk_keys_create` - (Optional) Specifies whether to create custom managed keys. Default is false.
- `cmkrsa_key_name` - (Optional) The name of the customer managed key with RSA algorithm to create. Default is `cmkrsa`.
- `cmkec_key_name` - (Optional) The name of the customer managed key with EC algorithm to create. Default is `cmkec`.
- `cmk_rotation_period` - (Optional) The time period after which the key should be rotated. Default is 18 months.
- `cmk_expiry_period` - (Optional) The time period after which the key should expire. Default is 2 years.

Example Inputs:

```hcl
key_vault = {
  name                            = "my-key-vault"
  tenant_id                       = "00000000-0000-0000-0000-000000000000"
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  purge_protection                = true
  default_action                  = "Deny"
  soft_delete_retention_days      = 30
  sku                             = "standard"
  cmkrsa_key_name                  = "cmkrsa"
  cmkec_key_name                   = "cmkec"
  cmk_keys_create                 = true

```
KEY_VAULT_DESCRIPTION
}

variable "key_vault_key" {
  type = map(object({
    name            = optional(string, null)
    curve           = optional(string, null)
    size            = optional(number, null)
    type            = optional(string, null)
    opts            = optional(list(string), null)
    expiration_date = optional(string, null)
    not_before_date = optional(string, null)
    rotation_policy = optional(object({
      automatic = optional(object({
        time_after_creation = optional(string, null)
        time_before_expiry  = optional(string, null)
      }), null)
      expire_after         = optional(string, null)
      notify_before_expiry = optional(string, null)
    }), null)
    tags = optional(map(string), {})
  }))
  default     = null
  description = <<KEY_DETAILS
This map describes the configuration for Azure Key Vault keys.

- `key_vault_id` - (Required) The ID of the Key Vault.
- `key_type` - (Required) The type of the key.
- `key_size` - (Required) The size of the key.
- `key_opts` - (Required) The key operations that are permitted.

Example Inputs:

```hcl
  key_vault_key = {
    key_rsa = {
      type = "RSA"
      size = 4096
      opts = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]
    }
    key_ec = {
      type = "EC"
      curve = "P-256"
      opts = ["sign", "verify"]
    }
  }
```
KEY_DETAILS
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
}
