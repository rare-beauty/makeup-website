#################################
# Resource Group
#################################
module "resourcegroup" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/resourcegroup?ref=v2.2"
  resource_group_name     = var.cfg.resource_group_name
  resource_group_location = var.cfg.resource_group_location
  # tags                  = local.tags
}

#################################
# Virtual Network
#################################
module "vnet" {
  source             = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/virtualnetwork?ref=v2.2"
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
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/subnet?ref=v2.2"
  rgname                  = module.resourcegroup.resource_group_name
  vnetname                = module.vnet.vnet_name
  subnet_name             = var.cfg.subnet_name
  subnet_address_prefixes = var.cfg.subnet_address_prefixes
  # tags                  = local.tags
  # new inputs
  location   = module.resourcegroup.resource_group_location
  create_nsg = false
  # nsg_name = "my-custom-nsg"  # optional
}

#################################
# Azure Container Registry
#################################
module "acr" {
  source              = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/acr?ref=v2.2"
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
  source                        = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/azurekeyvault?ref=v2.2"
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
  source       = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/aks?ref=v2.2"
  aks_name     = var.cfg.aks
  rgname       = module.resourcegroup.resource_group_name
  aks_location = module.resourcegroup.resource_group_location

  dns_prefix              = var.cfg.dns_prefix
  private_cluster_enabled = false
  node_count              = var.cfg.node_count
  vm_size                 = var.cfg.node_vm_size
  host_encryption_enabled = true
  local_account_disabled  = false
  oidc_issuer_enabled       = var.cfg.oidc_issuer_enabled
  workload_identity_enabled = var.cfg.workload_identity_enabled
  
  environment             = var.cfg.environment

  # Networking & ACR Integration
  vnet_subnet_id      = module.subnet.subnet_id
  acr_id              = module.acr.acr_id
  enable_azure_policy = true

}

#################################
#  Look up Key Vault scope (ID)
#################################

data "azurerm_kubernetes_cluster" "aks" {
  name                = var.cfg.aks
  resource_group_name = module.resourcegroup.resource_group_name
}


data "azurerm_key_vault" "kv_for_wi" {
  name                = module.keyvault.key_vault_name
  resource_group_name = module.resourcegroup.resource_group_name
}

#  UAMI for Workload Identity (per env)
#################################
resource "azurerm_user_assigned_identity" "wi_app" {
  name                = "uami-aks-kv-${var.cfg.environment}"
  location            = module.resourcegroup.resource_group_location
  resource_group_name = module.resourcegroup.resource_group_name
}

#################################
# Federated Identity Credential (OIDC trust AKS -> UAMI)
#################################
resource "azurerm_federated_identity_credential" "wi_fic" {
  name                = "fic-${var.cfg.environment}-${var.cfg.serviceaccount_name}"
  resource_group_name = module.resourcegroup.resource_group_name

  # REQUIRED join fields:
  parent_id = azurerm_user_assigned_identity.wi_app.id
  issuer    = data.azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject   = "system:serviceaccount:${var.cfg.k8s_namespace}:${var.cfg.serviceaccount_name}"
  audience  = ["api://AzureADTokenExchange"]
}

#################################
# RBAC Assignments 
################################
module "rbac" {
  source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/rbac?ref=v2.2"
  
  enabled = contains(["staging", "production"], var.cfg.environment)
  
  assignments = [
    {
      principal_id    = azurerm_user_assigned_identity.wi_app.principal_id
      role_definition = "Key Vault Secrets User"
      scope           = data.azurerm_key_vault.kv_for_wi.id
    }
  ]
}

#     # AKS can pull images from ACR
#     aks_acr_pull = {
#       principal_id    = module.aks.kubelet_identity
#       role_definition = "AcrPull"
#       scope           = module.acr.acr_id
#     }

 # aks can access keyvault
    # aks_kv_secrets = {
    #   principal_id    = module.aks.kubelet_identity
    #   role_definition = "Key Vault Secrets User"
    #   scope           = module.keyvault.key_vault_id
    # }
#   }  
# }

