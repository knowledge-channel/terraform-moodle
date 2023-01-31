# Generate random value for the login password
resource "random_password" "password" {
  length           = 12
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
  source     = "./modules/database"
  azurerm_rg = var.azurerm_rg
  password   = random_password.password.result
  tags       = var.tags
  # add optional params
}

module "storage" {
  source     = "./modules/storage"
  azurerm_rg = var.azurerm_rg
  tags       = var.tags
}

module "logs" {
  source     = "./modules/logs"
  azurerm_rg = var.azurerm_rg
  tags       = var.tags
}

module "containers" {
  source              = "./modules/containers"
  azurerm_rg          = var.azurerm_rg
  moodle_password     = random_password.password.result
  moodle_system_email = "no-reply@test.com"
  database_host       = module.database.host
  database_name       = module.database.name
  database_user       = module.database.user
  database_password   = module.database.password
  volume_share_name   = module.storage.share_name
  volume_storage_name = module.storage.name
  volume_access_key   = module.storage.access_key
  logs_workspace_id   = module.logs.workspace_id
  logs_access_key     = module.logs.access_key
  logs_app_insights   = module.logs.app_insights
  tags                = var.tags
}

module "cdn" {
  source     = "./modules/cdn"
  azurerm_rg = var.azurerm_rg
  origin     = module.containers.default_domain
  tags       = var.tags
}
