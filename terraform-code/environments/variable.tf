variable resource_group_name {
    type=string
    description = "this is resource group name"
}

variable resource_group_location {
    type=string
    description = "this is resource group location"
}

variable aks_name {
    type = string
    description = "aks cluster name"
}

variable "dns_prefix" {
    type = string
    description = "dns name"
}
variable "node_count" {
    type = string
    description = "nodes count"
}
variable "node_vm_size" {
    type = string
    description = "virtual machine size/type"
}
variable "environment" {
    type = string
    description = "environment"
}