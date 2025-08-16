output "resource_group_name" {
  value = module.resourcegroup.resource_group_name
}

output "aks_cluster_name" {
  value = module.aks.aks_name
}

output "aks_resource_group" {
  value = module.aks.rgname
}

output "aks_location" {
  value = module.aks.aks_location
}
