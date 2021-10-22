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
  source  = "andrewCluey/keyvault/azurerm//examples/no_PE"

  kv_config = {
    name                = "kv-test-deployment"
    location            = azurerm_resource_group.kv_test.location
    resource_group_name = azurerm_resource_group.kv_test.name
    sku_name            = "standard"
  }

  pe_name                     = "kv-test-deployment-pe"
  pe_subnet_id                = azurerm_subnet.example.id
  private_vault_dns_zone_name = "privatelink.vaultcore.azure.net"
  private_vault_dns_zone_ids  = ["/subscriptions/7df4fea2-d719-4abe-890b-37cd0298be98/resourceGroups/fw-test/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]

  role_assignments = {
    "Key Vault Secrets User"    = ["89c260bb-3eda-49b1-ba66-a6e4cb21d768", "d7bc8715-fab1-41cc-a086-d9abdb906fea"],
    "Contributor"               = ["4c9e9244-319f-497c-b6f7-399bc80c559e"],
    "Key Vault Secrets Officer" = ["71dedafe-2dcb-435b-9166-cfb3cbe251b2"]
  }

}

