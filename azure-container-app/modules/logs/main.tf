# moodle file of Log Analytics Workspace

# Recover Resource Group
data "azurerm_resource_group" "moodle" {
  name = var.azurerm_rg
}

# Azure Log Analytics
resource "azurerm_log_analytics_workspace" "moodle" {
  name                = "bitnami-moodle-logs"
  resource_group_name = data.azurerm_resource_group.moodle.name
  location            = data.azurerm_resource_group.moodle.location
  sku                 = var.sku
  retention_in_days   = 30
  tags                = var.tags
}

# Azure Application Insights
resource "azurerm_application_insights" "resource" {
  name                = "bitnami-moodle-insights"
  resource_group_name = data.azurerm_resource_group.moodle.name
  location            = data.azurerm_resource_group.moodle.location
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.moodle.id
  tags                = var.tags
}
