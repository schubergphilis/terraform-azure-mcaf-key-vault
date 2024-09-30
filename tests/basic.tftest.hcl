run "basic" {
  variables {
    resource_group = {
      name     = "my-resource-group"
      location = "East US"
    }

    key_vault = {
      name                            = "kv001"
      tenant_id                       = "your-tenant-id"
      enabled_for_disk_encryption     = false
      enabled_for_deployment          = false
      enabled_for_template_deployment = false
      enable_rbac_authorization       = true
      purge_protection                = true
      soft_delete_retention_days      = 30
      sku                             = "standard"
      ip_rules                        = []
      subnet_id                       = []
      network_bypass                  = "None"
      cmkrsa_keyname                  = "cmkrsa"
      cmkec_keyname                   = "cmkec"
      cmk_keys_create                 = true
    }

    tags = {
      Environment = "Production"
    }
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = output.key_vault_name == "kv001"
    error_message = "Unexpected output.key_vault_name value"
  }

  assert {
    condition     = output.cmk_ec_keyname == "cmkec"
    error_message = "Unexpected output.cmk_ec_keyname value"
  }

}