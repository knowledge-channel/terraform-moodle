# moodle file of MySQL Database

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

# Azure Container Group
resource "azurerm_container_group" "moodle" {
  name                = "moodle-container"
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name
  dns_name_label      = data.azurerm_resource_group.moodle.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = "bitnami-moodle"
    image  = "bitnami/moodle"
    cpu    = "2"
    memory = "4"

    environment_variables = {
      "BITNAMI_DEBUG"               = var.moodle_debug
      "MOODLE_USERNAME"             = var.moodle_admin
      "MOODLE_EMAIL"                = var.moodle_system_email
      "MOODLE_SITE_NAME"            = var.moodle_site_name
      "MOODLE_LANG"                 = var.moodle_lang
      "MOODLE_DATABASE_TYPE"        = "auroramysql"
      "MOODLE_DATABASE_HOST"        = var.database_host
      "MOODLE_DATABASE_NAME"        = var.database_name
      "MOODLE_DATABASE_USER"        = var.database_user
      "MOODLE_DATABASE_MIN_VERSION" = "5.6.47.0"
      "APACHE_HTTP_PORT_NUMBER"     = 80
      "PHP_MEMORY_LIMIT"            = "1024M"
    }

    secure_environment_variables = {
      "MOODLE_PASSWORD"          = var.moodle_password
      "MOODLE_DATABASE_PASSWORD" = var.database_password
    }

    volume {
      name       = "moodle"
      mount_path = "/bitnami/moodle"
      read_only  = false
      share_name = azurerm_storage_share.moodle.name

      storage_account_name = azurerm_storage_account.moodle.name
      storage_account_key  = azurerm_storage_account.moodle.primary_access_key
    }

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  exposed_port = [{
    port     = 80
    protocol = "TCP"
  }]

  tags = var.tags
}
