resource "azurerm_private_endpoint" "this" {
  count = local.should_create_pep_with_dns_zone_group ? 1 : 0

  location                      = var.private_endpoint.location != null ? var.private_endpoint.location : var.location
  name                          = var.private_endpoint.name
  resource_group_name           = var.private_endpoint.resource_group_name != null ? var.private_endpoint.resource_group_name : var.resource_group_name
  subnet_id                     = var.private_endpoint.subnet_id
  custom_network_interface_name = var.private_endpoint.custom_network_interface_name
  tags                          = var.private_endpoint.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = var.private_endpoint.private_service_connection_name != null ? var.private_endpoint.private_service_connection_name : "${var.private_endpoint.name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
  }

  dynamic "private_dns_zone_group" {
    for_each = length(var.private_endpoint.private_dns_zone_resource_ids) > 0 ? ["this"] : []

    content {
      name                 = var.private_endpoint.private_dns_zone_group_name
      private_dns_zone_ids = var.private_endpoint.private_dns_zone_resource_ids
    }
  }
}

#This PEP is used when the DNS is managed by policy
resource "azurerm_private_endpoint" "this_unmanaged_dns" {
  count = !local.should_create_pep_with_dns_zone_group ? 1 : 0

  location                      = var.private_endpoint.location != null ? var.private_endpoint.location : var.location
  name                          = var.private_endpoint.name
  resource_group_name           = var.private_endpoint.resource_group_name != null ? var.private_endpoint.resource_group_name : var.resource_group_name
  subnet_id                     = var.private_endpoint.subnet_id
  custom_network_interface_name = var.private_endpoint.custom_network_interface_name
  tags                          = var.private_endpoint.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = var.private_endpoint.private_service_connection_name != null ? var.private_endpoint.private_service_connection_name : "pse-${var.name}"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
  }

  lifecycle {
    ignore_changes = [private_dns_zone_group]
  }
}