# -------------------
# Resource Group
# -------------------
output "resource_group_name" {
  value       = module.resourcegroup.resource_group_name
  description = "Resource Group name"
}

output "resource_group_location" {
  value       = module.resourcegroup.resource_group_location
  description = "Resource Group location"
}

# -------------------
# Networking
# -------------------
output "vnet_name" {
  value       = module.vnet.vnet_name
  description = "Virtual Network name"
}

output "subnet_id" {
  value       = module.subnet.subnet_id
  description = "Subnet resource ID"
}

# -------------------
# ACR
# -------------------
output "acr_id" {
  value       = module.acr.acr_id
  description = "ACR resource ID"
}

# If (and only if) your ACR module exports this, keep it; otherwise delete it or add an output in the module.
# output "acr_login_server" {
#   value       = module.acr.login_server
#   description = "ACR login server (e.g., myacr.azurecr.io)"
# }

# -------------------
# Key Vault
# -------------------
output "key_vault_id" {
  value       = module.keyvault.key_vault_id
  description = "Key Vault resource ID"
}

# -------------------
# AKS -
# -------------------
output "aks_kubelet_identity" {
  value       = module.aks.kubelet_identity
  description = "AKS kubelet identity object ID"
}




