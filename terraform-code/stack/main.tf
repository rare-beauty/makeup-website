#################################
# Locals for Mongo DBs & Workload Identities
#################################
locals {
  # One logical Mongo database + one KV secret per microservice
  mongo_databases = {
    products = "product-mongo-connection"
    contact  = "contact-mongo-connection"
    reviews  = "reviews-mongo-connection"
    users    = "users-mongo-connection"
    orders   = "orders-mongo-connection"
  }

  # One UAMI + one ServiceAccount per microservice (SA names assumed)
  wi_microservices = {
    products = {
      sa_name = "products-sa"
    }
    contact = {
      sa_name = "contact-sa"
    }
    reviews = {
      sa_name = "reviews-sa"
    }
    users = {
      sa_name = "users-sa"
    }
    orders = {
      sa_name = "orders-sa"
    }
  }
}

#################################
# Resource Group
#################################
module "resourcegroup" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/resourcegroup?ref=v5"
  resource_group_name     = var.cfg.resource_group_name
  resource_group_location = var.cfg.resource_group_location
  # tags                  = local.tags
}

#################################
# Virtual Network
#################################
module "vnet" {
  source             = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/virtualnetwork?ref=v5"
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
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/subnet?ref=v5"
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
  source              = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/acr?ref=v5"
  resource_group_name = module.resourcegroup.resource_group_name
  location            = module.resourcegroup.resource_group_location
  acr_name            = var.cfg.acr_name
  sku                 = var.cfg.acr_sku
  admin_enabled       = false  # secure for staging/prod
  # tags              = local.tags
  public_network_access_enabled = var.cfg.acr_sku == "Premium" ? false : true
}

#################################
# Azure Key Vault
#################################
module "keyvault" {
  source                        = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/azurekeyvault?ref=v5"
  rg_name                       = module.resourcegroup.resource_group_name
  location                      = module.resourcegroup.resource_group_location
  kv_name                       = var.cfg.keyvault_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7
  public_network_access_enabled = var.cfg.public_network_access_enabled
  # tags                        = local.tags

  kv_network_default_action = var.cfg.kv_network_default_action
  kv_bypass                 = "AzureServices"
  kv_ip_rules               = []   # optional: add office/CICD egress CIDRs later
  kv_vnet_subnet_ids        = []   # optional: add private endpoint subnet later
}

#################################
# KV data-plane RBAC for Terraform principal
#################################
resource "azurerm_role_assignment" "tf_kv_secrets_officer" {
  scope                = module.keyvault.key_vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

#################################
# Database (Postgres)
#################################
module "database" {
  source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/database-db?ref=v5"

  # Common
  db_engine           = "postgres"                               # or "mssql" / "cosmos_mongo"
  name_prefix         = "${var.cfg.environment}-db01"
  db_name             = "makeupapp"
  resource_group_name = module.resourcegroup.resource_group_name
  location            = module.resourcegroup.resource_group_location

  # Key Vault (store connection string)
  key_vault_id   = module.keyvault.key_vault_id
  kv_secret_name = "db-connection"

  # Postgres quick-start (public; remember to lock this down later)
  pg_public_access_enabled   = true
  pg_temp_allow_all_firewall = true
  pg_admin_username          = "appadmin"
  pg_admin_password          = null   # auto-generate

  # tags = local.tags

  # 🔒 Ensure RBAC is in place before we try to Get/Set the secret
  depends_on = [
    azurerm_role_assignment.tf_kv_secrets_officer
  ]
}

#################################
# Database (Cosmos Mongo for a Mongo-based microservice)
#################################



module "mongo_database" {
  for_each = local.mongo_databases
  source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/database-db?ref=v5"

  # Common
  db_engine           = "cosmos_mongo"                          # <--- IMPORTANT
  name_prefix         = "${var.cfg.environment}-mongo-${each.key}"        # e.g. "staging-mongo01"
  db_name             = each.key                             # logical DB name inside Mongo
  resource_group_name = module.resourcegroup.resource_group_name
  location            = module.resourcegroup.resource_group_location

  # Key Vault (store Mongo connection string)
  key_vault_id   = module.keyvault.key_vault_id
  kv_secret_name = each.value                           # secret names in KV (e.g. used by micro-service)

  # If the module has extra cosmos-specific inputs, you can set them here.
  # Otherwise it will use sensible defaults for cosmos_mongo.

  depends_on = [
    azurerm_role_assignment.tf_kv_secrets_officer
  ]
}

 


#################################
# AKS Cluster
#################################
module "aks" {
  source       = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/aks?ref=v5"
  aks_name     = var.cfg.aks
  rgname       = module.resourcegroup.resource_group_name
  aks_location = module.resourcegroup.resource_group_location

  dns_prefix                = var.cfg.dns_prefix
  private_cluster_enabled   = false
  node_count                = var.cfg.node_count
  vm_size                   = var.cfg.node_vm_size
  host_encryption_enabled   = true
  local_account_disabled    = false
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
# data "azurerm_kubernetes_cluster" "aks" {
#   name                = var.cfg.aks
#   resource_group_name = module.resourcegroup.resource_group_name
# }

# data "azurerm_key_vault" "kv_for_wi" {
#   name                = module.keyvault.key_vault_name
#   resource_group_name = module.resourcegroup.resource_group_name
# }

###############################
#  UAMI for Workload Identity (per env)
#################################

resource "azurerm_user_assigned_identity" "wi_app" {
  for_each            = local.wi_microservices
  name                = "uami-${var.cfg.environment}-${each.key}" # e.g. uami-staging-products
  location            = module.resourcegroup.resource_group_location
  resource_group_name = module.resourcegroup.resource_group_name
}

#################################
# Federated Identity Credential (OIDC trust AKS -> UAMI)
#################################

resource "azurerm_federated_identity_credential" "wi_fic" {
  for_each            = local.wi_microservices
  name                = "fic-${var.cfg.environment}-${each.key}" # e.g. fic-staging-products
  resource_group_name = module.resourcegroup.resource_group_name

  parent_id = azurerm_user_assigned_identity.wi_app[each.key].id
  issuer    = module.aks.oidc_issuer_url
  subject   = "system:serviceaccount:${var.cfg.k8s_namespace}:${each.value.sa_name}"
  audience  = ["api://AzureADTokenExchange"]

  depends_on = [ module.aks ]
}


#################################
# RBAC Assignments 
#################################

module "rbac" {
  source  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//terraform/modules/rbac?ref=v5"
  enabled = contains(["staging", "production"], var.cfg.environment)

  assignments = merge(
    {
      # AKS can pull images from ACR
      aks_acr_pull = {
        principal_id    = module.aks.kubelet_identity
        role_definition = "AcrPull"
        scope           = module.acr.acr_id
      }
    },
    {
      # Each microservice UAMI can read secrets from Key Vault
      for svc, cfg in local.wi_microservices :
      "wi_kv_${svc}" => {
        principal_id    = azurerm_user_assigned_identity.wi_app[svc].principal_id
        role_definition = "Key Vault Secrets User"
        scope           = module.keyvault.key_vault_id
      }
    }
  )
}

#    

#  aks can access keyvault
#   aks_kv_secrets = {
#     principal_id    = module.aks.kubelet_identity
#     role_definition = "Key Vault Secrets User"
#     scope           = module.keyvault.key_vault_id
#   }
