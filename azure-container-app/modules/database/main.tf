# moodle file of MySQL Database

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

resource "azurerm_mysql_flexible_server" "moodle" {
  name                         = "moodle-mysql-server"
  resource_group_name          = data.azurerm_resource_group.moodle.name
  location                     = data.azurerm_resource_group.moodle.location
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

  tags = var.tags
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

resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "azure-resources"
  resource_group_name = data.azurerm_resource_group.moodle.name
  server_name         = azurerm_mysql_flexible_server.moodle.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
