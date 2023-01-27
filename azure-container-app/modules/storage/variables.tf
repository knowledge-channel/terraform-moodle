variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
