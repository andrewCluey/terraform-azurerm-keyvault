resource "azurerm_resource_group" "kv_test" {
  name     = "rg-kv-testing"
  location = "uksouth"
}


# vnet
resource "azurerm_virtual_network" "vn_test" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.kv_test.location
  resource_group_name = azurerm_resource_group.kv_test.name
  address_space       = ["10.0.0.0/16"]
}

# subnet
resource "azurerm_subnet" "example" {
  name                 = "kv-subnet"
  resource_group_name  = azurerm_resource_group.kv_test.name
  virtual_network_name = azurerm_virtual_network.vn_test.name
  address_prefixes     = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true # DISABLE the policy
}


module "test_key_vault" {
  source = "../../"

  kv_config = {
    name                = "kv-test-deployment"
    location            = azurerm_resource_group.kv_test.location
    resource_group_name = azurerm_resource_group.kv_test.name
    sku_name            = "standard"
  }

  pe_name                     = "kv-test-deployment-pe"
  pe_subnet_id                = azurerm_subnet.example.id
  private_vault_dns_zone_name = "privatelink.vaultcore.azure.net"
  private_vault_dns_zone_ids  = ["/subscriptions/7ddf-subscription-id-8be98/resourceGroups/rg-test/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]

  role_assignments = {
    "Key Vault Secrets User"    = ["89c260bb-object-ID-768", "object-id-a086-dfdgvrd906fea"],
    "Contributor"               = ["4c9e9244-319f-497c-b6f7-399bc80c559e"],
    "Key Vault Secrets Officer" = [""]
  }

}

