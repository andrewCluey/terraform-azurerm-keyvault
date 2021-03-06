# #######################################################
# Commmon variables. Usually required across ALL modules.
# #######################################################
variable "location" {
  description = "The Azure region to deploy the resources to. Defaults to West Europe."
  type        = string
  default     = "westeurope"
}

variable "resource_group_name" {
  description = "The name of the resource group where the new KEY VAULT should be created."
  type        = string
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
  description = "One or more IP addresses (in CIDR notation) that can access the KeyVault."
  type        = list(string)
  
#### EXAMPLE ####
  /*
  kv_allowed_cidr = ["10.0.0.0/24","10.1.0.0/24"]
  */
}

variable "kv_default_action" {
  description = "The Default Action to use when theres no match to the IP Rules. Possible values are Allow and Deny."
  type        = string
  default     = "Deny"
}

variable "pe_subnet_id" {
  description = "The ID of the Azure Subnet where the new private Endpoint for the Key vault will be created."
  type        = string
}

variable "private_vault_dns_zone_name" {
  description = "The name of the Private DNS zone for Private Endpoint"
  type        = string
}

variable "private_vault_dns_zone_id" {
  description = "The ID of the Private DNS zone for Private Endpoint"
  type        = string
}
