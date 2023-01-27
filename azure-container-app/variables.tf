variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
  default     = "bitnami-moodle"
}

variable "tags" {
  description = "Tags description for resources"
  type        = map(string)
  default     = {
    "bitnami-moodle" = "Bitnami Moodle full provisioned environment"
  }
}
