data "azurerm_client_config" "current" {
}

########################################################################################################################
# Creates a New KeyVault & Private Endpoint
########################################################################################################################

# Deploy the KeyVault
resource "azurerm_key_vault" "key_vault" {
  name                        = var.kv_config.name
  location                    = var.kv_config.location
  resource_group_name         = var.kv_config.resource_group_name
  sku_name                    = var.kv_config.sku_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = true
  enable_rbac_authorization   = true
  tags                        = var.tags

  network_acls {
    default_action = var.kv_default_action
    bypass         = "AzureServices"
    ip_rules       = var.kv_allowed_cidr
  }
}


################################################################################
# Create a new Private Endpoint - Optional
################################################################################
resource "azurerm_private_endpoint" "pe" {
  count               = var.pe_name == "" ? 0 : 1
  name                = var.pe_name
  location            = var.kv_config.location
  resource_group_name = var.kv_config.resource_group_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${var.kv_config.name}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = var.private_vault_dns_zone_name
    private_dns_zone_ids = var.private_vault_dns_zone_ids
  }
}



################################
# Create Role Assignments
################################

locals {
  principal_roles_list = flatten([  # Produce a list object, containing mapping of role names to principal IDs.
    for role, principals in var.role_assignments : [
        for principal in principals: {
            role = role
            principal = principal
        }
    ]
  ])

  principal_roles_map = { # convert the above list to a map
      for obj in local.principal_roles_list : obj.principal => obj
  }

}

resource "azurerm_role_assignment" "role_assignments" {
  for_each             = local.principal_roles_map
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = each.value.role
  principal_id         = each.value.principal
}
