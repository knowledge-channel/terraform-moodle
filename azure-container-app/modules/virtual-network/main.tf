# moodle file of Volume Blob Storage

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

resource "azurerm_virtual_network" "moodle" {
  name                = "${var.azurerm_rg}-vnet"
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "moodle_database" {
  name                 = "database-subnet"
  resource_group_name  = data.azurerm_resource_group.moodle.name
  virtual_network_name = azurerm_virtual_network.moodle.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_dns_zone" "moodle_database" {
  name                = "moodle.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.moodle.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "moodle_database" {
  name                  = "moodleDatabaseVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.moodle_database.name
  virtual_network_id    = azurerm_virtual_network.moodle.id
  resource_group_name   = data.azurerm_resource_group.moodle.name
}

resource "azurerm_subnet" "moodle_containers" {
  name                 = "containers-subnet"
  resource_group_name  = data.azurerm_resource_group.moodle.name
  virtual_network_name = azurerm_virtual_network.moodle.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_private_dns_zone" "moodle_containers" {
  name                = "moodle.azure.com"
  resource_group_name = data.azurerm_resource_group.moodle.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "moodle_containers" {
  name                  = "moodleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.moodle_containers.name
  virtual_network_id    = azurerm_virtual_network.moodle.id
  resource_group_name   = data.azurerm_resource_group.moodle.name
}

resource "azurerm_subnet" "moodle_bastion" {
  name                 = "bastion-subnet"
  resource_group_name  = data.azurerm_resource_group.moodle.name
  virtual_network_name = azurerm_virtual_network.moodle.name
  address_prefixes     = ["10.0.5.0/24"]
}

resource "azurerm_public_ip" "moodle_bastion" {
  name                = "bastion-static-ip"
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "${var.azurerm_rg}-bastionhost"
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.moodle_bastion.id
    public_ip_address_id = azurerm_public_ip.moodle_bastion.id
  }
}

