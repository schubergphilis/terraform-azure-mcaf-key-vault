terraform {
  required_version = ">= 1.7"
}

module "key_vault" {
  source = "../.."

  key_vault = {
    name                            = "my-key-vault"
    tenant_id                       = "your-tenant-id"
    resource_group_name             = "resource-group-name"
    enabled_for_disk_encryption     = true
    enabled_for_deployment          = false
    enabled_for_template_deployment = false
    enable_rbac_authorization       = true
    purge_protection                = true
    soft_delete_retention_days      = 30
    sku                             = "standard"
    ip_rules                        = []
    subnet_ids                      = []
    network_bypass                  = "AzureServices"
    cmkrsa_key_name                 = "cmkrsa"
    cmkec_key_name                  = "cmkec"
    cmk_keys_create                 = true
  }

  tags = {
    Environment = "Production"
  }
}
