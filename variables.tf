variable "name" {
  type        = string
  description = "The name of the Azure Key Vault."
  validation {
    condition     = length(var.name) <= 24 && length(var.name) >= 3 && can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "The name must be 3–24 characters long and contain only alphanumeric characters and hyphens."
  }
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID for authenticating requests to the Key Vault."
  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "The tenant_id must be a valid UUID."
  }
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the Key Vault will be created."
  validation {
    condition     = length(var.resource_group_name) >= 1
    error_message = "resource_group_name cannot be empty."
  }
}

variable "location" {
  type        = string
  default     = null
  description = "The location of the Key Vault. If not specified, the location of the calling module is used."
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Specifies if Azure Disk Encryption is permitted to retrieve secrets and unwrap keys."
}

variable "enabled_for_deployment" {
  type        = bool
  default     = false
  description = "Specifies if Azure Resource Manager is permitted to retrieve secrets."
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "Specifies if Azure Resource Manager templates can retrieve secrets."
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = true
  description = "Specifies whether Azure RBAC is used to authorize access instead of access policies."
}

variable "purge_protection" {
  type        = bool
  default     = true
  description = "Specifies whether purge protection is enabled for this Key Vault."
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 30
  description = "Number of days to retain soft deleted items."
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether public network access is allowed."
}

variable "default_network_action" {
  type        = string
  default     = "Deny"
  description = "The default action when no network rule matches. Usually 'Deny'."
  validation {
    condition     = contains(["Allow", "Deny"], var.default_network_action)
    error_message = "default_action must be either 'Allow' or 'Deny'."
  }
}

variable "sku" {
  type        = string
  default     = "standard"
  description = "The SKU name of the Key Vault. Can be 'standard' or 'premium'."
  validation {
    condition     = contains(["standard", "premium"], lower(var.sku))
    error_message = "sku must be either 'standard' or 'premium'."
  }
}

variable "ip_rules" {
  type        = list(string)
  default     = []
  description = "List of IP addresses allowed to access the Key Vault."
  validation {
    condition     = alltrue([for ip in var.ip_rules : can(regex("^\\d{1,3}(\\.\\d{1,3}){3}(/\\d{1,2})?$", ip))])
    error_message = "Each entry in ip_rules must be a valid IP address or CIDR block."
  }
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of subnet IDs allowed to access the Key Vault."
}

variable "network_bypass" {
  type        = string
  default     = "None"
  description = "Specifies which traffic can bypass network rules. Options: 'AzureServices', 'None'."
  validation {
    condition     = contains(["AzureServices", "None"], var.network_bypass)
    error_message = "network_bypass must be either 'AzureServices' or 'None'."
  }
}

variable "customer_managed_key" {
  type = object({
    rsa_key_name       = optional(string, "cmkrsa")
    rsa_key_size       = optional(string, 4096)
    rotation_period    = optional(string, "P18M")
    expiry_period      = optional(string, "P2Y")
    notify_period      = optional(string, "P30D")
    expiration_date    = optional(string)
    time_before_expiry = optional(string)
  })

  default = null

  description = <<KEY_DETAILS
Defines the configuration for a customer-managed RSA key in Azure Key Vault.

- `rsa_key_name` - (Optional) The name of the RSA key. Defaults to "cmkrsa".
- `rsa_key_size` - (Optional) The size of the RSA key in bits. Common values are 2048, 3072, or 4096. Defaults to 4096.
- `rotation_period` - (Optional) The duration before the key should be automatically rotated, in ISO 8601 format (e.g., P18M = 18 months). Defaults to "P18M".
- `expiry_period` - (Optional) The duration after which the key will expire, in ISO 8601 format (e.g., P2Y = 2 years). Defaults to "P2Y".
- `notify_period` - (Optional) The duration before key expiration to send a notification, in ISO 8601 format. Defaults to "P30D".
- `expiration_date` - (Optional) A specific RFC 3339 timestamp for when the key should expire. Overrides `expiry_period` if set.
- `time_before_expiry` - (Optional) A buffer duration before expiration to trigger pre-expiry actions or automation. if set rotation period will be ignored.
KEY_DETAILS
}

variable "key_vault_administrators" {
  description = "Set of Key vault Administrators"
  type = map(object({
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
    principal_type                   = optional(string)
  }))

  default = {}
}

variable "key_vault_crypto_users" {
  description = "Map of Key Vault Crypto Users"
  type = map(object({
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
    principal_type                   = optional(string)
  }))

  default = {}
}

variable "key_vault_secret_users" {
  description = "Map of Key Vault Secret Users"
  type = map(object({
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
    principal_type                   = optional(string, null)
  }))

  default = {}
}

variable "key_vault_certificate_users" {
  description = "Map of Key Vault Certificate Users"
  type = map(object({
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
    principal_type                   = optional(string)
  }))

  default = {}
}

variable "key_vault_encryption_users" {
  description = "Map of Key Vault Encryption Users"
  type = map(object({
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
    principal_type                   = optional(string)
  }))

  default = {}
}

variable "keys" {
  type = map(object({
    name            = optional(string)
    type            = optional(string)
    curve           = optional(string)
    size            = optional(number)
    opts            = optional(list(string), [])
    expiration_date = optional(string)
    not_before_date = optional(string)
    rotation_policy = optional(object({
      automatic = optional(object({
        time_after_creation = optional(string)
        time_before_expiry  = optional(string)
      }))
      expire_after         = optional(string)
      notify_before_expiry = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  default     = {}
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
  default     = {}
}