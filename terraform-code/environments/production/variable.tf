# Minimal root var so this folder accepts `cfg` from tfvars for staging & prod.
variable "cfg" {
  description = "Env config"
  type        = any
}
