# moodle file of Volume Blob Storage

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

# Azure Blob Storage
resource "azurerm_storage_account" "moodle" {
  name                          = "bitnamimoodlestorage"
  resource_group_name           = data.azurerm_resource_group.moodle.name
  location                      = data.azurerm_resource_group.moodle.location
  account_tier                  = var.account_tier
  account_kind                  = var.account_kind
  account_replication_type      = var.replication_type
  tags                          = var.tags
}

# Azure File Share
resource "azurerm_storage_share" "moodle" {
  name                 = "bitnami-moodle-share"
  storage_account_name = azurerm_storage_account.moodle.name
  quota                = 1024

}

# Block public access
resource "azurerm_storage_account_network_rules" "moodle" {
  storage_account_id = azurerm_storage_account.moodle.id

  default_action             = "Allow"
  ip_rules                   = []
  virtual_network_subnet_ids = []
  bypass                     = ["AzureServices"]

  depends_on = [
    azurerm_storage_share.moodle
  ]
}
