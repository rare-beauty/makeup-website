cfg = {
  resource_group_name     = "staging-rg"
  resource_group_location = "westus"

  v_name                  = "staging-vnet"
  address_ip              = ["10.10.0.0/16"]
  subnet_name             = "staging-subnet"
  subnet_address_prefixes = ["10.10.1.0/24"]

  acr_name = "stagingacr123"
  acr_sku  = "Basic"            # cheaper than Standard

  keyvault_name = "staging-kv123"

  aks          = "staging-aks"
  dns_prefix   = "stagingaks"
  node_count   = 1              # cheapest (1 node)
  node_vm_size = "Standard_B2s" # AKS needs >=2 vCPU; B1s won't work

  environment = "staging"
  //aks_module_ref = "main"
}
