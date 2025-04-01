variable "private_endpoint" {
  type = object({
    name                            = optional(string)
    location                        = optional(string)
    tags                            = optional(map(string), {})
    subnet_id                       = string
    private_dns_zone_group_name     = optional(string, "default")
    private_dns_zone_resource_ids   = optional(set(string), [])
    private_service_connection_name = optional(string)
    custom_network_interface_name   = optional(string)
    resource_group_name             = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Defines a private endpoint to create.

A Private endpoint supports the following attributes:

- `name` – (Optional) The name of the private endpoint. If omitted, a name will be auto-generated.
- `location` – (Optional) Azure region where the private endpoint will be created. If not specified, defaults to the location of the associated resource group.
- `tags` – (Optional) A map of tags to assign to the private endpoint. Defaults to an empty map.
- `subnet_id` – (Required) The full resource ID of the subnet in which to deploy the private endpoint.
- `private_dns_zone_group_name` – (Optional) The name of the DNS zone group to associate. Defaults to `"default"` if not set.
- `private_dns_zone_resource_ids` – (Optional) A set of private DNS zone resource IDs to link to the private endpoint. If not provided, no DNS zone association is made.
- `private_service_connection_name` – (Optional) The name of the private service connection. If not specified, a name will be generated.
- `custom_network_interface_name` – (Optional) Custom name for the network interface resource. If omitted, a default will be used.
- `resource_group_name` – (Optional) The resource group in which to create the private endpoint. If not set, it defaults to the resource group of the associated resource.

Use this variable to declaratively manage private endpoint instances, including DNS integration, naming, and network placement.
DESCRIPTION
}
variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  nullable    = false
}