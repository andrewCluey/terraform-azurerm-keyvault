###########################################
# Creates a New KeyVault & Private Endpoint
###########################################

data "azurerm_resource_group" "app_resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "pe_subnet" {
  name                 = var.pe_subnet_name
  resource_group_name  = var.pe_vnet_resource_group_name
  virtual_network_name = var.pe_vnet_name
}

# Deploy the Resources
resource "azurerm_key_vault" "key_vault" {
  name                        = var.kv_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = true
  tags                        = var.tags

  network_acls {
    default_action = var.kv_default_action
    bypass         = "AzureServices"
    ip_rules       = var.kv_allowed_cidr
  }
}

################################
# Creates a new Private Endpoint
################################

resource "azurerm_private_endpoint" "pe" {
  name                = "${var.kv_name}-pe"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.app_resource_group.name
  subnet_id           = data.azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${var.kv_name}-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.key_vault.id
  }

  private_dns_zone_group {
    name                 = var.private_vault_dns_zone_name
    private_dns_zone_ids = [var.private_vault_dns_zone_id]
  }
}