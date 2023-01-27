variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "sku" {
  description = "Service tier of new Log Workspace"
  type        = string
  default     = "Free"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
