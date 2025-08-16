module "resourcegroup" {
  source                  = "git::https://github.com/rare-beauty/terraform-infrastructure.git//resourcegroup"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "aks" {
    source = "git::https://github.com/rare-beauty/terraform-infrastructure.git//aks"
    aks_name = var.aks
    rgname    = module.resourcegroup.name
    aks_location  = module.resourcegroup.location

    dns_prefix            = var.dns_prefix                 
    node_count            = var.node_count                 
    node_vm_size          = var.node_vm_size
     
    environment  = var.environment
}


