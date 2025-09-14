#################################
# Resource Group
#################################
module "resourcegroup" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/resourcegroup?ref=v1"
  resource_group_name     = var.cfg.resource_group_name
  resource_group_location = var.cfg.resource_group_location
  # tags                  = local.tags
}

#################################
# Virtual Network
#################################
module "vnet" {
  source             = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/virtualnetwork?ref=v1"
  resourcegroup_name = module.resourcegroup.resource_group_name
  v_location         = module.resourcegroup.resource_group_location
  v_name             = var.cfg.v_name
  address_ip         = var.cfg.address_ip
  # tags             = local.tags
}

#################################
# Subnet
#################################
module "subnet" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/subnet?ref=v1"
  rgname                  = module.resourcegroup.resource_group_name
  vnetname                = module.vnet.vnet_name
  subnet_name             = var.cfg.subnet_name
  subnet_address_prefixes = var.cfg.subnet_address_prefixes
  # tags                  = local.tags
  # new inputs
  location   = module.resourcegroup.resource_group_location
  create_nsg = true
  # nsg_name = "my-custom-nsg"  # optional
}

#################################
# Azure Container Registry
#################################
module "acr" {
  source              = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/acr?ref=v1"
  resource_group_name = module.resourcegroup.resource_group_name
  location            = module.resourcegroup.resource_group_location
  acr_name            = var.cfg.acr_name
  sku                 = var.cfg.acr_sku
  admin_enabled       = false  # âœ… secure for staging/prod
  # tags              = local.tags
  public_network_access_enabled = var.cfg.acr_sku == "Premium" ? false : true
}

#################################
# Azure Key Vault
#################################
module "keyvault" {
  source                        = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/azurekeyvault?ref=v1"
  rg_name                       = module.resourcegroup.resource_group_name
  location                      = module.resourcegroup.resource_group_location
  kv_name                       = var.cfg.keyvault_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7
  public_network_access_enabled = false
  # tags                        = local.tags

  kv_network_default_action = "Deny"
  kv_bypass                 = "AzureServices"
  kv_ip_rules               = []   # optional: add office/CICD egress CIDRs later
  kv_vnet_subnet_ids        = []   # optional: add private endpoint subnet later
}

#################################
# AKS Cluster
#################################
module "aks" {
  source       = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/aks?ref=v1"
  aks_name     = var.cfg.aks
  rgname       = module.resourcegroup.resource_group_name
  aks_location = module.resourcegroup.resource_group_location

  dns_prefix              = var.cfg.dns_prefix
  private_cluster_enabled = true
  node_count              = var.cfg.node_count
  vm_size                 = var.cfg.node_vm_size
  host_encryption_enabled = true
  local_account_disabled  = false
  environment             = var.cfg.environment

  # Networking & ACR Integration
  vnet_subnet_id      = module.subnet.subnet_id
  acr_id              = module.acr.acr_id
  enable_azure_policy = true
  # log_analytics_workspace_id = var.cfg.log_analytics_workspace_id
  # tags                      = local.tags
}

#################################
# RBAC Assignments
#################################
module "rbac" {
  source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/rbac?ref=v1"
  # tags  = local.tags

  # No 'enabled' arg (to support older module versions).
  # Instead, conditionally pass assignments only in production.
  assignments = var.cfg.environment == "production" ? [
    # AKS can pull images from ACR
    {
      principal_id    = module.aks.kubelet_identity
      role_definition = "AcrPull"
      scope           = module.acr.acr_id
    },
    # AKS can access Key Vault secrets
    {
      principal_id    = module.aks.kubelet_identity
      role_definition = "Key Vault Secrets User"
      scope           = module.keyvault.key_vault_id
    }
  ] : []
}

