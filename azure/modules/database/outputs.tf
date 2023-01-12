output "subnet_address_prefixes" {
  value = azurerm_subnet.moodle.address_prefixes
}

output "database_host" {
  value = azurerm_mysql_flexible_server.moodle.fqdn
}

output "database_name" {
  value = azurerm_mysql_flexible_database.moodle.name
}

output "database_user" {
  value = azurerm_mysql_flexible_server.moodle.administrator_login
}

output "database_password" {
  value     = azurerm_mysql_flexible_server.moodle.administrator_password
  sensitive = true
}
