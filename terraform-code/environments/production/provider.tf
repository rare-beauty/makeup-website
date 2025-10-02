terraform {
  required_version = ">= 1.6.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.113.0, < 4.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-infra-staging"
    storage_account_name = "infrastatestaging01"
    container_name       = "tfstate"
    key                  = "infra/production.tfstate"
  }
}

provider "azurerm" {
  features {}
}