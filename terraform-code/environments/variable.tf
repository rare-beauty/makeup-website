variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "resource_group_location" {
  type        = string
  description = "Azure region for resources"
}

variable "v_name" {
  type        = string
  description = "Name of the Virtual Network"
}

variable "address_ip" {
  type        = list(string)
  description = "Address space for VNet"
}

variable "subnet_name" {
  type        = string
  description = "Name of the Subnet"
}

variable "subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for Subnet"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
}

variable "acr_sku" {
  type        = string
  description = "SKU for ACR (Basic, Standard, Premium)"
}

variable "keyvault_name" {
  type        = string
  description = "Azure Key Vault name"
}

# variable "tenant_id" {
#   type        = string
#   description = "Azure Tenant ID"
# }

variable "aks" {
  type        = string
  description = "Name of the AKS Cluster"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for AKS cluster"
}

variable "node_count" {
  type        = number
  description = "Number of nodes in AKS node pool"
}

variable "node_vm_size" {
  type        = string
  description = "VM size for AKS nodes"
}

variable "environment" {
  type        = string
  description = "Deployment environment (staging/prod)"
}
