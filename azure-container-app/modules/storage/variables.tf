variable "azurerm_rg" {
  description = "Azure Resource Groups"
  type        = string
}

variable "account_kind" {
  description = "Account kind of the storage account"
  default     = "StorageV2"
  type        = string

  validation {
    condition = contains(["Storage", "StorageV2"], var.account_kind)
    error_message = "The account kind of the storage account is invalid."
  }
}

variable "account_tier" {
  description = "Account tier of the storage account"
  default     = "Standard"
  type        = string

  validation {
    condition = contains(["Standard", "Premium"], var.account_tier)
    error_message = "The account tier of the storage account is invalid."
  }
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
