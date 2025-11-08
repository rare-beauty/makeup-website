cfg = {
  resource_group_name     = "prod-rgroup02"
  resource_group_location = "eastus2"

  v_name                  = "production-02"      # matches your schema
  address_ip              = ["10.20.0.0/16"] # matches your schema
  subnet_name             = "production-subnet02"
  subnet_address_prefixes = ["10.20.1.0/24"]

  acr_name = "prodacr02"
  acr_sku  = "Basic" # cheaper than Standard/Premium "free student account"

  keyvault_name = "prod-kv02"
  public_network_access_enabled = false
  kv_network_default_action = "Deny"

  aks          = "production-aks02"
  dns_prefix   = "productionaks02"
  node_count   = 1              # lowest cost
  node_vm_size = "Standard_B2s" # AKS-compatible, cheap
  oidc_issuer_enabled = true
  workload_identity_enabled = true

  k8s_namespace       = "makeup-production"
  serviceaccount_name = "wi-sa-prod"

  environment = "production" # or "prod" if you prefer; 
  //aks_module_ref = "68f8b1849a9241b11057ba3625a94f97b5acc242"
}
