# terraform-azurerm-keyvault

Terraform module to deploy KeyVault with a Private Endpoint

## Version History

- 1.0  
Initial release of the Key vault Module.
Deployed KeyVault with the following core settings:
  
  - disk encryption enabled
  - soft delete enabled
  - purge protection enabled
  - rbac authorization enabled

By default, Private Endpoint was created (so a vNET and Subnet was required before using this module.)

- 2.0
Second release. Changes to input parameter format. Using Input Objects for required variables.
Basic settings remain the same:

  - disk encryption enabled
  - soft delete enabled
  - purge protection enabled
  - rbac authorization enabled

Private Endpoint is no longer a requirement. If the Private endpoint name variable (`pe_name`) is left at the default value (`""`), then Private Endpoint will not be deployed.
Role assignments can now be deployed with the key vault. A new input param (`role_assignments`) is now required to define the roles to assign to the key vault.
  EXAMPLE Input:

```js
role_assignments = {
    "Key Vault Secrets User"    = ["89c23eda-bw44-v6f2cg52d5rf", "efds715-ref2-36dd-r4rw-34rfdfw906fea"],
    "Contributor"               = ["3ed54578-354t-346h-f44e-3erfds559e"],
    "Key Vault Secrets Officer" = []
}
```

- 2.0.1
Fixed a bug in role_assignments whereby assinging multiple roles to the same user (such as secrets User and Contributor) would generate an error.

## Service Principals - Which ID?

When assigning roles to a Service Principal using terraform, the object ID/AppID visible from within the portal is not supported through the API.

Instead, the ObjectID has to be obtained from the command line using this AZ CLi command:

`az ad sp list --display-name "Integration App E2E user"`

## Usage

```js
resource "azurerm_resource_group" "resource_group" {
  name     = "resources"
  location = "uksouth"
}

module "keyvault" {
  source  = "gitrepo/keyvault/azurerm"

  resource_group_name         = azurerm_resource_group.resource_group.name
  location                    = "uksouth"
  kv_name                     = "nameofkeyvault"
  vnet_resource_group_name    = "privateendpoint-vnet-resourcegroup"
  vnet_name                   = "privateendpoint-vnet-name"
  kv_allowed_cidr             = ["77.66.55.0/24","21.22.23.0/18"]
  pe_subnet_id                = data.azurerm_subnet.default.id
  private_vault_dns_zone_name = "privatelink.vaultcore.windows.net"
  private_vault_dns_zone_id   = "/subscriptions/xxxxxxxxuuuuuuuuu/resourceGroups/dnszoneResourceGroup/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  
  role_assignments = {
    "Key Vault Secrets User"    = ["22faewf-we4r-3q4v-w3df-34rfweafawe"]
    "Contributor"               = ["22faewf-we4r-3q4v-w3df-34rfweafawe"]
    "Key Vault Secrets Officer" = []
    "Owner"                     = ["87f4fe47-wsdf-34rt-974fr-432ed0arght"]
  }
  
  tags = { 
    Terraform = "true",
    environment = "DEV"
  }
}
```

## Arguments

| Name | Type | Required | Description |
| --- | --- | --- | --- |
|location | string | Optional | The Azure region to deploy Key Vault to. Default of UKSOUTH |
|resource_group_name | string | Required | The name of the Resource Group where the new Key Vault will be created. |
|kv_name | string | Required | The name to assign to the new Key Vault |
|kv_sku | string | Optional | The Key Vault SKU to deploy. Defaults to Standard. |
|kv_allowed_cidr | list | Optional | A list of IP addresses (in CIDR notation) that are allowed to access the Key Vault over the Internet. |
|kv_default_action | string | Optional | Is the default NCL set to allow or deny access to the keyvault? defaults to Deny.|
|pe_subnet_id ||||
|private_vault_dns_zone_name ||||
|private_vault_dns_zone_id ||||
|role_assignments | map(object) | Required | Defines the Roles to assign to the new Key Vault. ANy valid role can be assigned using this parameter. See above for an example.|
