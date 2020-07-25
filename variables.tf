# #######################################################
# Commmon variables. Usually required across ALL modules.
# #######################################################
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

variable "kv_allowed_subnet_names" {
  description = "List of subnet names that are allowed to connect to this key vault using the service endpoint."
  type        = list(string)
  default     = null
}

variable "kv_ip_rules" {
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
  type        = list(string)
  default     = null
}

variable "kv_default_action" {
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type        = string
  default     = "Deny"
}

variable "vnet_resource_group_name" {
  description = "The name of the resource group where allowed subnets reside"
  type        = string
}

variable "vnet_name" {
  description = "The name of the vNET where the subnet is located"
  type        = string
}
