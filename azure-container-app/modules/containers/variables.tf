variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "moodle_debug" {
  description = "Start Moodle with debug tools, like logs and more"
  type        = string
  default     = true
}

variable "moodle_admin" {
  description = "Moodle Default Admin User"
  type        = string
  default     = "bitnami-moodle"
}

variable "moodle_password" {
  description = "Moodle Default Admin Password"
  type        = string
  sensitive   = true
}

variable "moodle_system_email" {
  description = "Moodle no Reply System Email"
  type        = string
}

variable "moodle_site_name" {
  description = "Moodle Site Name"
  type        = string
  default     = "bitnami"
}

variable "moodle_lang" {
  description = "Moodle Default Language"
  type        = string
  default     = "pt_br"
}

variable "database_host" {
  description = "Database host"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "database_user" {
  description = "Database admin user"
  type        = string
}

variable "database_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "volume_share_name" {
  description = "File Share to use as volume"
  type        = string
}

variable "volume_storage_name" {
  description = "File Storage to use as volume"
  type        = string
}

variable "volume_access_key" {
  description = "File Storage Access Key"
  type        = string
  sensitive   = true
}

variable "logs_workspace_id" {
  description = "Log Analytics Workspace Id"
  type        = string
}

variable "logs_access_key" {
  description = "Log Analytics Workspace Access Key"
  type        = string
  sensitive   = true
}


variable "logs_app_insights" {
  description = "Application Insights For Environment"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
