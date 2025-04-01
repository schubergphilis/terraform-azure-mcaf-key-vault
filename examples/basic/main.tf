terraform {
  required_version = ">= 1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.5, < 5.0"
    }
  }
}

module "key_vault" {
  source = "../.."

  name                = "my-key-vault"
  tenant_id           = "e55dda83-e842-4de8-9889-2903a7ebaf15"
  resource_group_name = "resource-group-name"

  network_bypass      = "AzureServices"
  cmkrsa_key_name     = "cmkrsa"
  cmk_keys_create     = true
  cmk_expiration_date = "2030-12-31T00:00:00Z"

  tags = {
    Environment = "Production"
  }

  key_vault_certificate_users = {
    azure_devops_user = {
      principal_id = "e55dda83-e842-4de8-9889-2903a7ebaf15"
  } }
}
