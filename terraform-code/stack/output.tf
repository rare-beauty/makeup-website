output "resource_group_name" {
  value = module.resourcegroup.name
}

output "vnet_id" {
  value = module.vnet.id
}

output "subnet_id" {
  value = module.subnet.id
}

output "acr_id" {
  value = module.acr.id
}

output "keyvault_id" {
  value = module.keyvault.id
}

output "aks_cluster_name" {
  value       = module.aks.name
  description = " my AKS cluster name "
}

output "aks_kubelet_identity" {
  value = module.aks.kubelet_identity
}

# ACR login server for pipelines
output "acr_login_server" {
  value       = module.acr.login_server
  description = "The login server of the Azure Container Registry (used in CI/CD pipelines)"
}