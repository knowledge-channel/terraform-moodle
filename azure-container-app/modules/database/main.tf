# moodle file of MySQL Database

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

resource "azurerm_private_dns_zone" "moodle" {
  name                = "moodle.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.moodle.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "moodle" {
  name                  = "moodleDatabaseVnetZone.com"
  resource_group_name   = data.azurerm_resource_group.moodle.name
  private_dns_zone_name = azurerm_private_dns_zone.moodle.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_mysql_flexible_server" "moodle" {
  name                         = "moodle-mysql-server"
  resource_group_name          = data.azurerm_resource_group.moodle.name
  location                     = data.azurerm_resource_group.moodle.location
  delegated_subnet_id          = var.subnet_id
  private_dns_zone_id          = azurerm_private_dns_zone.moodle.id
  administrator_login          = var.user
  administrator_password       = var.password
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  sku_name                     = var.sku
  version                      = "5.7"
  zone                         = "1"

  storage {
    iops    = 450
    size_gb = 50
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.moodle]
  tags       = var.tags
}

resource "azurerm_mysql_flexible_server_configuration" "moodle" {
  name                = "require_secure_transport"
  resource_group_name = data.azurerm_resource_group.moodle.name
  server_name         = azurerm_mysql_flexible_server.moodle.name
  value               = "OFF"
}

# Create a MySQL Flexible Server Database
resource "azurerm_mysql_flexible_database" "moodle" {
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
  name                = "moodle-db"
  resource_group_name = data.azurerm_resource_group.moodle.name
  server_name         = azurerm_mysql_flexible_server.moodle.name
}
