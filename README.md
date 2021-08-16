# terraform-azurerm-keyvault
Terraform module to deploy KeyVault with a Private Endpoint

## Usage
```hcl
resource "azurerm_resource_group" "resource_group" {
  name     = "resources"
  location = "westeurope"
}

module "keyvault" {
  source  = "gitrepo/keyvault/azurerm"

  resource_group_name         = azurerm_resource_group.resource_group.name
  location                    = "westeurope"
  kv_name                     = "nameofkeyvault"
  vnet_resource_group_name    = "privateendpoint-vnet-resourcegroup"
  kv_allowed_cidr             = ["10.0.0.0/24","10.1.0.0/24"]
  pe_subnet_id                = data.azurerm_subnet.default.id
  soft_delete_retention_days  = 21
  private_vault_dns_zone_name = "privatelink.vaultcore.windows.net"
  private_vault_dns_zone_id   = "/subscriptions/xxxxxxxxuuuuuuuuu/resourceGroups/dnszoneResourceGroup/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  tags = { 
    Terraform = "true",
    environment = "DEV"
  }
}
```