variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "origin" {
  description = "Origin for Expose in Edge CDN"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
