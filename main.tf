locals {
  kv_pe_name = var.kv_pe_name != "" ? var.kv_pe_name : "${var.kv_name}-pip"
}


###########################################
# Creates a New KeyVault & Private Endpoint
###########################################

# Deploy the KeyVault
resource "azurerm_key_vault" "key_vault" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = var.purge_protection_enabled
  enable_rbac_authorization   = true
  soft_delete_retention_days  = var.soft_delete_retention_days
  tags                        = var.tags

  network_acls {
    default_action             = var.kv_default_action
    bypass                     = "AzureServices"
    ip_rules                   = var.kv_allowed_cidr
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }
}

################################
# Create a new Private Endpoint
################################

resource "azurerm_private_endpoint" "pe" {
  name                = local.kv_pe_name 
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "${var.kv_name}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = var.private_vault_dns_zone_name
    private_dns_zone_ids = [var.private_vault_dns_zone_id]
  }
}
