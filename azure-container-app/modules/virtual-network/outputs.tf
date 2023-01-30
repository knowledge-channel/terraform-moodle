output "vnet_id" {
  value = azurerm_virtual_network.moodle.id
}

output "database_subnet_id" {
  value = azurerm_subnet.moodle_database.id
}

output "containers_subnet_id" {
  value = azurerm_subnet.moodle_containers.id
}
