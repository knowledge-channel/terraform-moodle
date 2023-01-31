variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "account_kind" {
  description = "Account kind of the storage account"
  default     = "FileStorage"
  type        = string
}

variable "account_tier" {
  description = "Account tier of the storage account"
  default     = "Premium"
  type        = string
}

variable "replication_type" {
  description = "Replication type of the storage account"
  default     = "LRS"
  type        = string

  validation {
    condition = contains(["LRS", "ZRS"], var.replication_type)
    error_message = "The replication type of the storage account is invalid."
  }
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
