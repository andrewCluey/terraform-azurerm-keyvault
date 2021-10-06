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

By default, Private Endpoint is created (so a vNET and Subnet are required.

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
    "Key Vault Secrets User"    = ["89c23eda-object-id", "efds715-object-id-34rfdfw906fea"],
    "Contributor"               = ["3ed54578-object-id-f23e-3e59e"],
    "Key Vault Secrets Officer" = ["243eyrtuj-3-object-id-xf54b2"]
}
```

## Service Principals - Which ID?

When assigning roles to a Service Principal using terraform, use the ObjectID obtained from the command line using this AZ CLi command:

`az ad sp list --display-name "SP Display Name"`

## Usage


## Arguments
| Name | Type | Required | Description |
| --- | --- | --- | --- |
|kv_config| object(map) | Required | An input object to configure the Key vault. See below for further details. |
|kv_allowed_cidr | list | Optional | A list of IP addresses (in CIDR notation) that are allowed to access the Key Vault over the Internet. |
|kv_default_action| string | Optional | Is the default NCL set to allow or deny access to the keyvault? defaults to Deny.|
|role_assignments| map | Required | An map of role assignments to assign to the Key vault. See below for further details. |
|pe_name| string | Optional | Use if you want the Key Vault to have a Private Endpoint. If set, then `pe_subnet_id` is also required. |
|pe_subnet_id | string | Optional | Required if `pe_name` is set. The ID of the Azure Subnet where the new private Endpoint for the Key vault will be created.|
|private_vault_dns_zone_name | string | Optional | The name of the Private DNS zone for Private Endpoint. Required if a Private Endpoint is being created. |
|private_vault_dns_zone_id | string | Optional | The ID of the Private DNS zone for Private Endpoint. Required if a Private Endpoint is being created. |

## kv_config

This input object requires the following settings to be defined:

- name
- location
- resource_group_name
- sku_name
- soft_delete_retention_days
