output "azurerm_mysql_flexible_server" {
  value = azurerm_mysql_flexible_server.moodle.name
}

output "mysql_flexible_server_database_name" {
  value = azurerm_mysql_flexible_database.moodle.name
}
