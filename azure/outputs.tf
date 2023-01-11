output "moodle_database_server" {
  description = "Display Database Server name"
  value = module.database.azurerm_mysql_flexible_server
}

output "moodle_database_name" {
  description = "Display Database name"
  value = module.database.mysql_flexible_server_database_name
}