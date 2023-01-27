output "workspace_id" {
  value = azurerm_log_analytics_workspace.moodle.workspace_id
}

output "access_key" {
  value     = azurerm_log_analytics_workspace.moodle.primary_shared_key
  sensitive = true
}
