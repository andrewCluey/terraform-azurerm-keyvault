# terraform-azurerm-keyvault
Terraform module to deploy KeyVault with a Private Endpoint

## Version History

- 1.0  
Initial release of the Key vault Module.
Deployed KeyVault with the following core settings:
  
  * disk encryption enabled
  * soft delete enabled
  * purge protection enabled
  * rbac authorization enabled

By default, Private Endpoint was created (so a vNET and Subnet was required before using this module.)

- 2.0
Second release. Changes to input parameter format. Using Input Objects for required variables.
Basic settings remain the same:

  * disk encryption enabled
  * soft delete enabled
  * purge protection enabled
  * rbac authorization enabled

Private Endpoint is no longer a requirement. If the Private endpoint name variable (`pe_name`) is left at the default value (`""`), then Private Endpoint will not be deployed.
Role assignments can now be deployed with the key vault. A new input param (`role_assignments`) is nmow required to define the roles to assign to the key vault.
  EXAMPLE Input:
```json
role_assignments = {
    "Key Vault Secrets User"    = ["89c23eda-bw44-v6f2cg52d5rf", "efds715-ref2-36dd-r4rw-34rfdfw906fea"],
    "Contributor"               = ["3ed54578-354t-346h-f44e-3erfds559e"],
    "Key Vault Secrets Officer" = ["22gyrtuj-3tym-267b-54df-xfg3rgh654b2"]
}
```


## Service Principals - Which ID?

When assigning roles to a Service Principal using terraform, the object ID/AppID visible from within the portal is not supported through the API.

Instead, the ObjectID has to be obtained from the command line using this AZ CLi command:

`az ad sp list --display-name "Integration App E2E user"`

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
  vnet_name                   = "privateendpoint-vnet-name"
  kv_allowed_cidr             = ["10.0.0.0/24","10.1.0.0/24"]
  pe_subnet_id                = data.azurerm_subnet.default.id
  private_vault_dns_zone_name = "privatelink.vaultcore.windows.net"
  private_vault_dns_zone_id   = "/subscriptions/xxxxxxxxuuuuuuuuu/resourceGroups/dnszoneResourceGroup/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  tags = { 
    Terraform = "true",
    environment = "DEV"
  }
}
```

## Arguments
| Name | Type | Required | Description |
| --- | --- | --- | --- |
|location| string | Optional | The Azure region to deploy Key Vault to. Default of UKSOUTH |
|resource_grouo_name| string | Required | The name of the Resource Group where the new Key Vault will be created. |
|kv_name | string | Required |The name to assign to the new Key Vault |
|kv_sku | string | Optional | The Key Vault SKU to deploy. Defaults to Standard. |
|kv_allowed_cidr | list | Optional | A list of IP addresses (in CIDR notation) that are allowed to access the Key Vault over the Internet. |
|kv_default_action| string | Optional | Is the default NCL set to allow or deny access to the keyvault? defaults to Deny.|
|pe_subnet_id ||||
|private_vault_dns_zone_name ||||
|private_vault_dns_zone_id ||||

