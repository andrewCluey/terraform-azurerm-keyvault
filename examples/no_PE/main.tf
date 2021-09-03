resource "azurerm_resource_group" "kv_test" {
  name     = "rg-kv-testing"
  location = "uksouth"
}


module "test_key_vault" {
  source = "../../"
  #source = "git::ssh://git@ssh.dev.azure.com/v3/Innocentdrinks/Azure%20Infrastructure/terraform-azurerm--key-vault?ref=feature/roleAssignment"

  kv_config = {
    name                = "kv-test-deployment"
    location            = azurerm_resource_group.kv_test.location
    resource_group_name = azurerm_resource_group.kv_test.name
    sku_name            = "standard"
  }

  role_assignments = {
    "Key Vault Secrets User"    = ["89c260bb-3eda-49b1-ba66-a6e4cb21d768", "d7bc8715-fab1-41cc-a086-d9abdb906fea"],
    "Contributor"               = ["4c9e9244-319f-497c-b6f7-399bc80c559e"],
    "Key Vault Secrets Officer" = ["71dedafe-2dcb-435b-9166-cfb3cbe251b2"]
  }

}

