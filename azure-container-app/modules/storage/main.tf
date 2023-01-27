# moodle file of Volume Blob Storage

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

# Azure Blob Storage
resource "azurerm_storage_account" "moodle" {
  name                     = "bitnamimoodlestorage"
  resource_group_name      = data.azurerm_resource_group.moodle.name
  location                 = data.azurerm_resource_group.moodle.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

# Azure File Share
resource "azurerm_storage_share" "moodle" {
  name                 = "bitnami-moodle-share"
  storage_account_name = azurerm_storage_account.moodle.name
  quota                = 50
}
