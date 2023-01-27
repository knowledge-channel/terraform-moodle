output "host" {
  value = azurerm_mysql_flexible_server.moodle.fqdn
}

output "name" {
  value = azurerm_mysql_flexible_database.moodle.name
}

output "user" {
  value = azurerm_mysql_flexible_server.moodle.administrator_login
}

output "password" {
  value     = azurerm_mysql_flexible_server.moodle.administrator_password
  sensitive = true
}
