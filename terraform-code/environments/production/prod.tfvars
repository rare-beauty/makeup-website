resource_group_name     = "prod-rg"
resource_group_location = "eastus2"

vnet_name              = "prod-vnet"
vnet_address_space     = ["10.20.0.0/16"]
subnet_name            = "prod-subnet"
subnet_address_prefixes = ["10.20.1.0/24"]

acr_name = "prodacr123"
acr_sku  = "Premium"

keyvault_name = "prod-kv123"
//tenant_id     = "YOUR-TENANT-ID"

aks        = "prod-aks"
dns_prefix = "prodaks"
node_count = 3
node_vm_size = "Standard_DS3_v2"

environment = "prod"
