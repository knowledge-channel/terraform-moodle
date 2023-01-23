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

variable "tags" {
  description = "Tags description for resources"
  type        = map(string)
  default     = {
    "bitnami-moodle" = "Bitnami Moodle full provisioned environment"
  }
}