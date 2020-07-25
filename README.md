# terraform-azurerm-keyvault
Terraform module to deploy KeyVault with a Private Endpoint

## Usage
```hcl
resource "azurerm_resource_group" "resource_group" {
  name     = "resources"
  location = "West Europe"
}

module "storageaccount" {
  source  = "gitrepo/keyvault/azurerm"
  version = "0.0.1"

  resource_group_name         = azurerm_resource_group.resource_group.name
  kv_name                     = "nameofkeyvault"
  vnet_resource_group_name    = "privateendpoint-vnet-resourcegroup"
  vnet_name                   = "privateendpoint-vnet-name"
  pe_subnet_name              = "privateendpoint-subnet-name"
  private_vault_dns_zone_name = "privatelink.vaultcore.windows.net"
  private_vault_dns_zone_id   = "/subscriptions/xxxxxxxxuuuuuuuuu/resourceGroups/dnszoneResourceGroup/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  tags = { Terraform = "true",
    environment = "DEV"
  }
}
```