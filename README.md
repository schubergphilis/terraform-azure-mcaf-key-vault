# terraform-azure-mcaf-key-vault
Terraform module to deploy a key vault with defaults, and optionaly some customer managed keys keys.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_key.cmkrsa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.this_unmanaged_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the Azure Key Vault. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the Key Vault will be created. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | The Azure Active Directory tenant ID for authenticating requests to the Key Vault. | `string` | n/a | yes |
| <a name="input_client_administrator_access"></a> [client\_administrator\_access](#input\_client\_administrator\_access) | Provide the current client that creates the Key vault administrator access | `bool` | `true` | no |
| <a name="input_cmk_expiration_date"></a> [cmk\_expiration\_date](#input\_cmk\_expiration\_date) | Optional expiration date for the key (ISO 8601 format). | `string` | `null` | no |
| <a name="input_cmk_expiry_period"></a> [cmk\_expiry\_period](#input\_cmk\_expiry\_period) | The key expiry period (ISO 8601 duration). | `string` | `"P2Y"` | no |
| <a name="input_cmk_keys_create"></a> [cmk\_keys\_create](#input\_cmk\_keys\_create) | Whether to create customer-managed keys (CMKs). | `bool` | `false` | no |
| <a name="input_cmk_notify_period"></a> [cmk\_notify\_period](#input\_cmk\_notify\_period) | The notification period before key expiry or rotation. | `string` | `"P30D"` | no |
| <a name="input_cmk_rotation_period"></a> [cmk\_rotation\_period](#input\_cmk\_rotation\_period) | The key rotation period (ISO 8601 duration). | `string` | `"P18M"` | no |
| <a name="input_cmkrsa_key_name"></a> [cmkrsa\_key\_name](#input\_cmkrsa\_key\_name) | Name of the RSA CMK to create. | `string` | `"cmkrsa"` | no |
| <a name="input_default_network_action"></a> [default\_network\_action](#input\_default\_network\_action) | The default action when no network rule matches. Usually 'Deny'. | `string` | `"Deny"` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Specifies whether Azure RBAC is used to authorize access instead of access policies. | `bool` | `true` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Specifies if Azure Resource Manager is permitted to retrieve secrets. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Specifies if Azure Disk Encryption is permitted to retrieve secrets and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | Specifies if Azure Resource Manager templates can retrieve secrets. | `bool` | `false` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | List of IP addresses allowed to access the Key Vault. | `list(string)` | `[]` | no |
| <a name="input_keys"></a> [keys](#input\_keys) | This map describes the configuration for Azure Key Vault keys.<br/><br/>- `key_vault_id` - (Required) The ID of the Key Vault.<br/>- `key_type` - (Required) The type of the key.<br/>- `key_size` - (Required) The size of the key.<br/>- `key_opts` - (Required) The key operations that are permitted.<br/><br/>Example Inputs:<pre>hcl<br/>  key_vault_key = {<br/>    key_rsa = {<br/>      type = "RSA"<br/>      size = 4096<br/>      opts = ["encrypt", "decrypt", "sign", "verify", "wrapKey", "unwrapKey"]<br/>    }<br/>    key_ec = {<br/>      type = "EC"<br/>      curve = "P-256"<br/>      opts = ["sign", "verify"]<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    name            = optional(string, null)<br/>    type            = optional(string)<br/>    curve           = optional(string, null)<br/>    size            = optional(number, null)<br/>    opts            = optional(list(string), [])<br/>    expiration_date = optional(string, null)<br/>    not_before_date = optional(string, null)<br/>    rotation_policy = optional(object({<br/>      automatic = optional(object({<br/>        time_after_creation = optional(string, null)<br/>        time_before_expiry  = optional(string, null)<br/>      }), null)<br/>      expire_after         = optional(string, null)<br/>      notify_before_expiry = optional(string, null)<br/>    }), null)<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the Key Vault. If not specified, the location of the calling module is used. | `string` | `null` | no |
| <a name="input_network_bypass"></a> [network\_bypass](#input\_network\_bypass) | Specifies which traffic can bypass network rules. Options: 'AzureServices', 'None'. | `string` | `"None"` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | Defines a map of private endpoints to create. Each item in the map represents a single private endpoint configuration. The keys are arbitrary and used only for iteration—they do not impact naming or deployment behavior.<br/><br/>Each private endpoint supports the following attributes:<br/><br/>- `name` – (Optional) The name of the private endpoint. If omitted, a name will be auto-generated.<br/>- `location` – (Optional) Azure region where the private endpoint will be created. If not specified, defaults to the location of the associated resource group.<br/>- `tags` – (Optional) A map of tags to assign to the private endpoint. Defaults to an empty map.<br/>- `subnet_id` – (Required) The full resource ID of the subnet in which to deploy the private endpoint.<br/>- `private_dns_zone_group_name` – (Optional) The name of the DNS zone group to associate. Defaults to `"default"` if not set.<br/>- `private_dns_zone_resource_ids` – (Optional) A set of private DNS zone resource IDs to link to the private endpoint. If not provided, no DNS zone association is made.<br/>- `private_service_connection_name` – (Optional) The name of the private service connection. If not specified, a name will be generated.<br/>- `custom_network_interface_name` – (Optional) Custom name for the network interface resource. If omitted, a default will be used.<br/>- `resource_group_name` – (Optional) The resource group in which to create the private endpoint. If not set, it defaults to the resource group of the associated resource.<br/><br/>Use this variable to declaratively manage private endpoint instances, including DNS integration, naming, and network placement. | <pre>map(object({<br/>    name                            = optional(string, null)<br/>    location                        = optional(string, null)<br/>    tags                            = optional(map(string), {})<br/>    subnet_id                       = string<br/>    private_dns_zone_group_name     = optional(string, "default")<br/>    private_dns_zone_resource_ids   = optional(set(string), [])<br/>    private_service_connection_name = optional(string, null)<br/>    custom_network_interface_name   = optional(string, null)<br/>    resource_group_name             = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group) | Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy. | `bool` | `true` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Specifies whether public network access is allowed. | `bool` | `false` | no |
| <a name="input_purge_protection"></a> [purge\_protection](#input\_purge\_protection) | Specifies whether purge protection is enabled for this Key Vault. | `bool` | `true` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Role assignments scoped to the Key Vault. | <pre>map(object({<br/>    role_definition_name             = string<br/>    principal_id                     = string<br/>    skip_service_principal_aad_check = optional(bool, false)<br/>    principal_type                   = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU name of the Key Vault. Can be 'standard' or 'premium'. | `string` | `"standard"` | no |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Number of days to retain soft deleted items. | `number` | `30` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs allowed to access the Key Vault. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cmkrsa_id"></a> [cmkrsa\_id](#output\_cmkrsa\_id) | CMK RSA Key ID |
| <a name="output_cmkrsa_key_name"></a> [cmkrsa\_key\_name](#output\_cmkrsa\_key\_name) | CMK RSA Key Name |
| <a name="output_cmkrsa_resource_resource_id"></a> [cmkrsa\_resource\_resource\_id](#output\_cmkrsa\_resource\_resource\_id) | CMK RSA Key Resource ID |
| <a name="output_cmkrsa_resource_versionless_id"></a> [cmkrsa\_resource\_versionless\_id](#output\_cmkrsa\_resource\_versionless\_id) | CMK RSA Key Versionless Resource ID |
| <a name="output_cmkrsa_versionless_id"></a> [cmkrsa\_versionless\_id](#output\_cmkrsa\_versionless\_id) | CMK RSA Key Versionless ID |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | n/a |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | n/a |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | n/a |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
