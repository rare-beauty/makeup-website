#################################
# Resource Group
#################################
module "resourcegroup" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//resourcegroup"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

#################################
# Virtual Network
#################################
module "vnet" {
  source        = "git::https://github.com/rare-beauty/terraform-infrastructure.git//virtualnetwork"
  rg_name       = module.resourcegroup.name
  location      = module.resourcegroup.location
  vnet_name     = var.vnet_name
  address_space = var.vnet_address_space
}

#################################
# Subnet
#################################
module "subnet" {
  source           = "git::https://github.com/rare-beauty/terraform-infrastructure.git//subnet"
  rg_name          = module.resourcegroup.name
  vnet_name        = module.vnet.name
  subnet_name      = var.subnet_name
  address_prefixes = var.subnet_address_prefixes
}

#################################
# Azure Container Registry
#################################
module "acr" {
  source        = "git::https://github.com/rare-beauty/terraform-infrastructure.git//acr"
  rg_name       = module.resourcegroup.name
  location      = module.resourcegroup.location
  acr_name      = var.acr_name
  sku           = var.acr_sku
  admin_enabled = false # ✅ secure for staging/prod
}

#################################
# Azure Key Vault
#################################
module "keyvault" {
  source                   = "git::https://github.com/rare-beauty/terraform-infrastructure.git//azurekeyvault"
  rg_name                  = module.resourcegroup.name
  location                 = module.resourcegroup.location
  keyvault_name            = var.keyvault_name
  tenant_id                = var.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = true
  soft_delete_enabled      = true
}

#################################
# AKS Cluster
#################################
module "aks" {
  source       = "git::https://github.com/rare-beauty/terraform-infrastructure.git//aks"
  aks_name     = var.aks
  rgname       = module.resourcegroup.name
  aks_location = module.resourcegroup.location

  dns_prefix   = var.dns_prefix
  node_count   = var.node_count
  node_vm_size = var.node_vm_size
  environment  = var.environment

  # Networking & ACR Integration
  vnet_subnet_id = module.subnet.id
  acr_id         = module.acr.id
}

#################################
# RBAC Assignments
#################################
module "rbac" {
  source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//rbac"

  assignments = [
    # AKS can pull images from ACR
    {
      principal_id    = module.aks.kubelet_identity
      role_definition = "AcrPull"
      scope           = module.acr.id
    },
    # AKS can access Key Vault secrets
    {
      principal_id    = module.aks.kubelet_identity
      role_definition = "Key Vault Secrets User"
      scope           = module.keyvault.id
    }
  ]
}
