# moodle file of Azure CDN

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

# CDN Profile
resource "azurerm_cdn_profile" "moodle" {
  name                = "bitnami-moodle-cdn"
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name
  sku                 = "Standard_Verizon"
  tags                = var.tags
}

# CDN Endpoint
resource "azurerm_cdn_endpoint" "moodle" {
  name                = "bitnami-moodle"
  profile_name        = azurerm_cdn_profile.moodle.name
  location            = data.azurerm_resource_group.moodle.location
  resource_group_name = data.azurerm_resource_group.moodle.name

  origin {
    name      = "bitnami-moodle"
    host_name = var.origin
  }

  tags = var.tags
}
