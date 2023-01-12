variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
  default     = "bitnami-moodle"
}

variable "azurerm_location" {
  description = "Azure Location"
  type        = string
  default     = "eastus"
}

variable "azurerm_vnet" {
  description = "Azure Virtual Network"
  type        = string
  default     = "bitnami-moodle-vnet"
}

variable "tags" {
  description = "Tags description for resources"
  type        = map(string)
  default     = {
    "bitnami-moodle" = "Bitnami Moodle full provisioned environment"
  }
}
