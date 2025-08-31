terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "~> 3.0"
      version = "4.42.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorage30aug"
    container_name       = "tfstate"
    key                  = "staging.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
