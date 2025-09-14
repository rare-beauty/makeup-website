terraform {
  required_version = ">= 1.6.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.113.0, < 4.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg4"
    storage_account_name = "tfstatestorage30sept123"
    container_name       = "tfstate4"
    use_azuread_auth     = true
    key                  = "staging.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
