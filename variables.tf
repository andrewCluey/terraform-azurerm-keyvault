# #######################################################
# Commmon variables. Usually required across ALL modules.
# #######################################################
variable "location" {
  description = "The Azure region to deploy the resources to. Defaults to West Europe."
  type        = string
  default     = "West Europe"
}

variable "resource_group_name" {
  description = "The name of the resource group where the new KEY VAULT should be created."
  type        = string
}

variable "tenant_id" {
  description = "The Id of the Azure AD Tenant where the resources will be created"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to be assigned to the new resource"
  type        = map(string)
  default     = null
}

####################################
# Variables specific to this module.
####################################
variable "kv_name" {
  description = "The name to assign to the new KeyVault"
  type        = string
}

variable "kv_allowed_cidr" {
  description = "One or IP address (in CIDR notation) that can access the KeyVault."
  type        = list(string)
  default     = null
}

variable "kv_default_action" {
  description = "The Default Action to use when theres no match to the IP Rules. Possible values are Allow and Deny."
  type        = string
  default     = "Deny"
}

variable "pe_subnet_name" {
  description = "name of the subnet where the new Private Endpoint for KeyVault should be created."
  type        = string
  default     = null
}

variable "vnet_resource_group_name" {
  description = "The name of the resource group where the Private Endpoint subnet resides"
  type        = string
}

variable "vnet_name" {
  description = "The name of the vNET where the Private Endpoint subnet is located"
  type        = string
}

variable "private_vault_dns_zone_name" {
  description = "The name of the Private DNS zone for Privatelink VaultCore"
  type        = string
}

variable "private_vault_dns_zone_id" {
  description = "The ID of the Private DNS zone for Privatelink VaultCore"
  type        = string
}