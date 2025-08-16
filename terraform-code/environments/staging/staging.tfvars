resource_group_name     = "staging-rg"
resource_group_location = "eastus"

vnet_name              = "staging-vnet"
vnet_address_space     = ["10.10.0.0/16"]
subnet_name            = "staging-subnet"
subnet_address_prefixes = ["10.10.1.0/24"]

acr_name = "stagingacr123"
acr_sku  = "Standard"

keyvault_name = "staging-kv123"
tenant_id     = "YOUR-TENANT-ID"

aks        = "staging-aks"
dns_prefix = "stagingaks"
node_count = 2
node_vm_size = "Standard_DS2_v2"

environment = "staging"
