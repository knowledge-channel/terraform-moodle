output "workspace_id" {
  value = azurerm_log_analytics_workspace.moodle.workspace_id
}

output "access_key" {
  value     = azurerm_log_analytics_workspace.moodle.primary_shared_key
  sensitive = true
}

output "app_insights" {
  value = azurerm_application_insights.resource.instrumentation_key
}
