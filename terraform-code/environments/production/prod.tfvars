cfg = {
  resource_group_name     = "prod-rg"
  resource_group_location = "eastus2"

  v_name                  = "prod-vnet"      # matches your schema
  address_ip              = ["10.20.0.0/16"] # matches your schema
  subnet_name             = "prod-subnet"
  subnet_address_prefixes = ["10.20.1.0/24"]

  acr_name = "prodacr123"
  acr_sku  = "Basic" # cheaper than Standard/Premium 

  keyvault_name = "prod-kv123"

  aks          = "prod-aks"
  dns_prefix   = "prodaks"
  node_count   = 1              # lowest cost
  node_vm_size = "Standard_B2s" # AKS-compatible, cheap

  environment = "production" # or "prod" if you prefer; 
  //aks_module_ref = "68f8b1849a9241b11057ba3625a94f97b5acc242"
}
