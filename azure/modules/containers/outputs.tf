output "moodle_host" {
  value = azurerm_container_group.moodle.fqdn
}