terraform {
  required_version = ">= 1.7"
}

module "azure_core" {
  source = "../.."

  resource_group = {
    name     = "my-resource-group"
    location = "East US"
  }

  key_vault = {
    name                            = "my-key-vault"
    tenant_id                       = "your-tenant-id"
    enabled_for_disk_encryption     = true
    enabled_for_deployment          = false
    enabled_for_template_deployment = false
    enable_rbac_authorization       = true
    purge_protection                = true
    soft_delete_retention_days      = 30
    sku                             = "standard"
    ip_rules                        = []
    subnet_id                       = []
    network_bypass                  = "AzureServices"
    cmkrsa_keyname                  = "cmkrsa"
    cmkec_keyname                   = "cmkec"
    cmk_keys_create                 = true
  }

  tags = {
    Environment = "Production"
  }
}
