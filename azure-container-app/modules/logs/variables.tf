variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "sku" {
  description = "Service tier of new Log Workspace"
  type        = string
  default     = "PerGB2018"

  validation {
    condition = contains(["Free", "Standalone", "PerNode", "PerGB2018"], var.sku)
    error_message = "The log analytics sku is incorrect."
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
