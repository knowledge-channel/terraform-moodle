output "share_name" {
  value = azurerm_storage_share.moodle.name
}

output "name" {
  value = azurerm_storage_account.moodle.name
}

output "access_key" {
  value     = azurerm_storage_account.moodle.primary_access_key
  sensitive = true
}
