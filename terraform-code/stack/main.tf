#################################
# Resource Group
#################################
module "resourcegroup" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//resourcegroup?ref=123979a43315e4f16478d0ca733994ac465797c7"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.tags
}

#################################
# Virtual Network
#################################
module "vnet" {
  source             = "git::https://github.com/rare-beauty/terraform-infrastructure.git//virtualnetwork?ref=123979a43315e4f16478d0ca733994ac465797c7"
  resourcegroup_name = module.resourcegroup.resource_group_name
  v_location         = module.resourcegroup.resource_group_location
  v_name             = var.v_name
  address_ip         = var.address_ip
  tags               = local.tags
}

#################################
# Subnet
#################################
module "subnet" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//subnet?ref=123979a43315e4f16478d0ca733994ac465797c7"
  rgname                  = module.resourcegroup.resource_group_name
  vnetname                = module.vnet.vnet_name
  subnet_name             = var.subnet_name
  subnet_address_prefixes = var.subnet_address_prefixes
  tags                    = local.tags
}

#################################
# Azure Container Registry
#################################
module "acr" {
  source              = "git::https://github.com/rare-beauty/terraform-infrastructure.git//acr?ref=123979a43315e4f16478d0ca733994ac465797c7"
  resource_group_name = module.resourcegroup.resource_group_name
  location            = module.resourcegroup.resource_group_location
  acr_name            = var.acr_name
  sku                 = var.acr_sku
  admin_enabled       = false # ✅ secure for staging/prod
  tags                = local.tags
}

#################################
# Azure Key Vault
#################################

data "azurerm_client_config" "current" {}

module "keyvault" {
  source                     = "git::https://github.com/rare-beauty/terraform-infrastructure.git//azurekeyvault?ref=123979a43315e4f16478d0ca733994ac465797c7"
  rg_name                    = module.resourcegroup.resource_group_name
  location                   = module.resourcegroup.resource_group_location
  kv_name                    = var.keyvault_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = true
  soft_delete_retention_days = 7
  tags                       = local.tags
}

#################################
# AKS Cluster
#################################
module "aks" {
  source       = "git::https://github.com/rare-beauty/terraform-infrastructure.git//aks?ref=123979a43315e4f16478d0ca733994ac465797c7"
  aks_name     = var.aks
  rgname       = module.resourcegroup.resource_group_name
  aks_location = module.resourcegroup.resource_group_location

  dns_prefix  = var.dns_prefix
  node_count  = var.node_count
  vm_size     = var.node_vm_size
  environment = var.environment

  # Networking & ACR Integration
  vnet_subnet_id = module.subnet.subnet_id
  acr_id         = module.acr.acr_id
  tags           = local.tags
}

#################################
# RBAC Assignments
#################################
module "rbac" {
  source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//rbac?ref=123979a43315e4f16478d0ca733994ac465797c7"
  tags   = local.tags
  assignments = [
    # AKS can pull images from ACR
    {
      principal_id    = module.aks.kubelet_identity
      role_definition = "AcrPull"
      scope           = module.acr.acr_id
    },
    # AKS cluster can access Key Vault secrets
    {
      principal_id    = module.aks.kubelet_identity
      role_definition = "Key Vault Secrets User"
      scope           = module.keyvault.key_vault_id
    }
  ]
}
