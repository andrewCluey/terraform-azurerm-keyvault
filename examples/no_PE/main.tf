resource "azurerm_resource_group" "kv_test" {
  name     = "rg-kv-testing"
  location = "uksouth"
}


module "test_key_vault" {
  source  = "andrewCluey/keyvault/azurerm//examples/no_PE"
  
  kv_config = {
    name                       = "kv-asc97687-test"
    location                   = azurerm_resource_group.kv_test.location
    resource_group_name        = azurerm_resource_group.kv_test.name
    sku_name                   = "standard"
    soft_delete_retention_days = "90"
  }

  role_assignments = {
    "Key Vault Secrets User"    = ["22faewf-we4r-3q4v-w3df-34rfweafawe"]
    "Contributor"               = ["22rfaewf-we4r-3q4v-w3df-34rfweafawe"]
    "Key Vault Secrets Officer" = []
    "Owner"                     = ["87f4fe47-wsdf-34rt-974fr-432ed0arght"]
  }
}

