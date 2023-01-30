output "vnet_id" {
  value = azurerm_virtual_network.moodle.id
}

output "database_subnet_id" {
  value = azurerm_subnet.moodle_database.id
}

output "database_dns_zone_id" {
  value = azurerm_private_dns_zone_virtual_network_link.moodle_database.id
}

output "containers_subnet_id" {
  value = azurerm_subnet.moodle_containers.id
}

output "containers_dns_zone_name" {
  value = azurerm_private_dns_zone_virtual_network_link.moodle_containers.name
}
