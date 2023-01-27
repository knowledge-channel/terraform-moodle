variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "user" {
  description = "Database admin user"
  type        = string
  default     = "moodle_db_admin"
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

variable "tags" {
  description = "Resource tags"
  type        = map(string) 
}