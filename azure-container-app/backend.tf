# The block below configures Terraform to use the 'remote' backend with Terraform Cloud.
# For more information, see https://www.terraform.io/docs/backends/types/remote.html
terraform {
  backend "remote" {
    organization = "knowledge-channel"

    workspaces {
      name = "azure-container-app-moodle"
    }
  }

  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }

    azapi = {
      source = "Azure/azapi"
      version = "~>0.4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}
