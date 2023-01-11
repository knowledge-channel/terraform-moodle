# moodle file of MySQL Database

# Recover Resource Group
resource "azurerm_resource_group" "moodle" {
  name      = var.azurerm_rg
  location  = var.azurerm_location
}

# Recover VNet
resource "azurerm_virtual_network" "moodle" {
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.moodle.location
  name                = var.azurerm_vnet
  resource_group_name = azurerm_resource_group.moodle.name
}

# Subnet
resource "azurerm_subnet" "moodle" {
  name                 = var.azurerm_subnet
  resource_group_name  = azurerm_resource_group.moodle.name
  virtual_network_name = azurerm_virtual_network.moodle.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  
  delegation {
    name = "flexible-server"

    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "moodle" {
  name                = "moodle.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.moodle.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "moodle" {
  name                  = "moodle.com"
  private_dns_zone_name = azurerm_private_dns_zone.moodle.name
  virtual_network_id    = azurerm_virtual_network.moodle.id
  resource_group_name   = azurerm_resource_group.moodle.name
}

resource "azurerm_mysql_flexible_server" "moodle" {
  name                          = "moodle-mysql-server"
  resource_group_name           = azurerm_resource_group.moodle.name
  location                      = azurerm_resource_group.moodle.location
  administrator_login           = var.user
  administrator_password        = var.password
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  delegated_subnet_id           = azurerm_subnet.moodle.id
  private_dns_zone_id           = azurerm_private_dns_zone.moodle.id
  sku_name                      = var.sku
  version                       = "5.7"

  storage {
    iops    = 360
    size_gb = 20
  }

  tags       = var.tags
  depends_on = [azurerm_private_dns_zone_virtual_network_link.moodle]
}

# Create a MySQL Flexible Server Database
resource "azurerm_mysql_flexible_database" "moodle" {
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
  name                = "moodle-db"
  resource_group_name = azurerm_resource_group.moodle.name
  server_name         = azurerm_mysql_flexible_server.moodle.name
  tags                = var.tags
}