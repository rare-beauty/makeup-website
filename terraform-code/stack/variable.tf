variable "cfg" {
  description = "Environment configuration (everything in one object)."
  type = object({
    resource_group_name     = string
    resource_group_location = string

    v_name     = string
    address_ip = list(string)

    subnet_name             = string
    subnet_address_prefixes = list(string)

    acr_name = string
    acr_sku  = string

    keyvault_name = string

    aks          = string
    dns_prefix   = string
    node_count   = number
    node_vm_size = string
    environment  = string
    oidc_issuer_enabled = bool
    workload_identity_enabled = bool
    k8s_namespace           = string
    serviceaccount_name     = string
  })
}

# Separate variable for module reference
# variable "module_ref" {
#   description = "Git reference (tag/branch/commit) for infrastructure modules"
#   type        = string
#   default     = "main"
# }