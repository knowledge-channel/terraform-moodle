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
  default     = "moodle-db-subnet"
}

variable "user" {
  description = "Database admin user"
  type        = string
  default     = "moodle-db-admin"
}

variable "password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

# See https://learn.microsoft.com/azure/mysql/flexible-server/concepts-service-tiers-storage#service-tiers-size-and-server-types
variable "sku" {
  description = "Service tier of new Database"
  type        = string
  default     = "B_Standard_B2s"
}