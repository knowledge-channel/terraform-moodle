# Generate random value for the login password
resource "random_password" "password" {
  length           = 8
  lower            = true
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  numeric          = true
  override_special = "_"
  special          = true
  upper            = true
}

module "database" {
  source            = "./modules/database"
  azurerm_rg        = var.azurerm_rg
  azurerm_location  = var.azurerm_location
  azurerm_vnet      = var.azurerm_vnet
  password          = random_password.password.result
  tags              = var.tags
  # add optional params
}

module "containers" {
  source                  = "./modules/containers"
  azurerm_rg              = var.azurerm_rg
  azurerm_location        = var.azurerm_location
  azurerm_vnet            = var.azurerm_vnet
  moodle_password         = random_password.password.result
  moodle_system_email     = "email@test.com"
  database_subnet_address = module.database.subnet_address_prefixes
  database_host           = module.database.database_host
  database_name           = module.database.database_name
  database_user           = module.database.database_user
  database_password       = module.database.database_password
  tags                    = var.tags
}