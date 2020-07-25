###########################################
# Creates a new Virtual network and subnets
###########################################

data "azurerm_resource_group" "app_resource_group" {
  name = var.resource_group_name
}

data "azurerm_subnet" "subnets" {
  resource_group_name  = var.vnet_resource_group_name
  virtual_network_name = var.vnet_name
}

# LOCALS
locals {
  kv_name = "${var.resource_group_name}-kv"
}

# Deploy the Resources
resource "azurerm_key_vault" "key_vault" {
  name                        = local.kv_name
  location                    = data.azurerm_resource_group.app_resource_group.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"
  soft_delete_enabled         = true
  purge_protection_enabled    = true
  tags                        = var.tags

  network_acls {
    default_action             = var.kv_default_action
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [for i in data.azurerm_subnet.subnets : i.id]
    ip_rules                   = var.kv_ip_rules
  }
}
