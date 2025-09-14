cfg = {
  resource_group_name     = "prod-rg4"
  resource_group_location = "eastus2"

  v_name                  = "production-vnet"      # matches your schema
  address_ip              = ["10.20.0.0/16"] # matches your schema
  subnet_name             = "production-subnet"
  subnet_address_prefixes = ["10.20.1.0/24"]

  acr_name = "prodacr947"
  acr_sku  = "Basic" # cheaper than Standard/Premium "free student account"

  keyvault_name = "prod-kv947"

  aks          = "production-aks"
  dns_prefix   = "productionaks"
  node_count   = 1              # lowest cost
  node_vm_size = "Standard_B2s" # AKS-compatible, cheap

  environment = "production" # or "prod" if you prefer; 
  //aks_module_ref = "68f8b1849a9241b11057ba3625a94f97b5acc242"
}
