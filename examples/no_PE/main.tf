resource "azurerm_resource_group" "kv_test" {
  name     = "rg-kv-testing"
  location = "uksouth"
}


module "test_key_vault" {
  source = "../../"

  kv_config = {
    name                = "kv-test-deployment"
    location            = azurerm_resource_group.kv_test.location
    resource_group_name = azurerm_resource_group.kv_test.name
    sku_name            = "standard"
  }

  role_assignments = {
    "Key Vault Secrets User"    = ["89c260bb-object-ID-768", "object-id-a086-dfdgvrd906fea"],
    "Contributor"               = ["4c9e9244-319f-497c-b6f7-399bc80c559e"],
    "Key Vault Secrets Officer" = [""]
  }

}

