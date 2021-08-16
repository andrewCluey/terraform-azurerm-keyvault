
output "id" {
  description = "The ID of the newly deployed Key Vault."
  value       = azurerm_key_vault.key_vault.id
}


output "vault_uri" {
  description = "The URI of the newly created Key Vault."
  value       = azurerm_key_vault.key_vault.vault_uri
}
