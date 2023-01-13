variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "azurerm_location" {
  description = "Azure Location"
  type        = string
}

variable "azurerm_vnet" {
  description = "Azure Virtual Network"
  type        = string
}

variable "azurerm_subnet" {
  description = "Azure Virtual Subnet"
  type        = string
  default     = "moodle-bitnami-subnet"
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

variable "database_subnet_address" {
  description = "Database Subnet Address Prefix"
  type        = list(string) 
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

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
