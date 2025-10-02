cfg = {
  resource_group_name     = "staging-rgroup010"
  resource_group_location = "westus"

  v_name                  = "stage-vnet010"
  address_ip              = ["10.10.0.0/16"]
  subnet_name             = "stage-subnet01"
  subnet_address_prefixes = ["10.10.1.0/24"]

  acr_name = "stagingacr010"
  acr_sku  = "Basic" # cheaper than Standard

  keyvault_name = "staging-010"

  aks          = "stage-aks010"
  dns_prefix   = "stageaks010"
  node_count   = 1             
  node_vm_size = "Standard_B2s" # AKS needs >=2 vCPU; B1s won't work

  environment = "staging"
  
}
