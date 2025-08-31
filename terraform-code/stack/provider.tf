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
    #key                  = "staging.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  # Use the env-specific subscription passed in via cfg
  subscription_id = var.cfg.subscription_id
}

data "azurerm_client_config" "current" {}

locals {
  tags = {
    env        = var.cfg.environment
    managed-by = "terraform"
  }

  # Base repo + ref to your modules (adjust paths/ref to match your repo!)
  #module_repo = "git::https://github.com/rare-beauty/terraform-infrastructure.git//"
  #module_ref  = "?ref=v0.1.0"  # <— pin a tag/commit/branch you control
}

