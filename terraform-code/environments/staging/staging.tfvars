cfg = {
  resource_group_name     = "staging-rgroup02"
  resource_group_location = "westus"

  v_name                  = "stage-vnet02"
  address_ip              = ["10.10.0.0/16"]
  subnet_name             = "stage-subnet02"
  subnet_address_prefixes = ["10.10.1.0/24"]

  acr_name = "stagingacr02"
  acr_sku  = "Basic" # cheaper than Standard

  keyvault_name = "staging-kv02"
  public_network_access_enabled = true
  kv_network_default_action = "Allow"

  aks          = "stage-aks02"
  dns_prefix   = "stageaks02"
  node_count   = 1             
  node_vm_size = "Standard_B2s" # AKS needs >=2 vCPU; B1s won't work
  oidc_issuer_enabled = true
  workload_identity_enabled = true
  k8s_namespace       = "makeup-staging"
    
  environment = "staging"
  
}
