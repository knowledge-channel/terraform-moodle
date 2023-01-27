output "workspace_id" {
  value = azurerm_storage_account.moodle.name
}

output "access_key" {
  value     = azurerm_storage_account.moodle.primary_access_key
  sensitive = true
}
