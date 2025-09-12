# Minimal root var so this folder accepts `cfg` from tfvars.
variable "cfg" {
  description = "Env config"
  type        = any
}

variable "module_ref" {
  description = "Reference to the infrastructure modules version (branch, tag, or commit)"
  type        = string
  default     = "main"
}