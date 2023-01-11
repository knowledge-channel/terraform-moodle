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
  # add optional params
}