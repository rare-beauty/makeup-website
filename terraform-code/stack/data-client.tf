#data "azurerm_client_config" "current" {}

locals {
    tags = {
        env = var.cfg.environment
        managed-by = "terraform"
    }
}